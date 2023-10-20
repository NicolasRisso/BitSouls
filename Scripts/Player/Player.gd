extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK
}

#MOVEMENT
export var ACCELERATION = 1000
export var MAX_SPEED = 80
export var FRICTION = 500
#ROLL
export var ROLL_SPEED = 90
export var AFTER_ROLL_MOMENTUM = 0.5
#INVINCIBILITY DURATION
export(float) var INVINCIBILITY_DURATION = 0.5
export(int) var MAX_ATTACK_BUFFER = 1
export(int) var MAX_ROLL_BUFFER = 1
#STAMINA CONSUPTION
export(int) var staminaPerAttack = 15
export(int) var staminaPerRoll = 30

var state = MOVE

var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN

var stats = PlayerStats

var attackbuffering = 0
var rollbuffering = 0

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var hurtbox = $Hurtbox
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true

func _physics_process(delta):
	bufferRead()
	match state:
		MOVE:
			move_state(delta)
			states()
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func states():
	if (attackbuffering > 0): state = ATTACK
	if (rollbuffering > 0): state = ROLL
	
func bufferRead():
	if Input.is_action_just_pressed("attack") and stats.stamina >= staminaPerAttack:
		increaseAttackBuffering()
	if Input.is_action_just_pressed("roll") and stats.stamina >= staminaPerRoll:
		increaseRollBuffering()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		rollVector = input_vector
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_state(delta):
	velocity = rollVector * ROLL_SPEED 
	animationState.travel("Roll")
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)
	move()
	
func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity *= AFTER_ROLL_MOMENTUM
	state = MOVE

func increaseAttackBuffering():
	if (attackbuffering < MAX_ATTACK_BUFFER):
		attackbuffering += 1

func increaseRollBuffering():
	if (rollbuffering < MAX_ROLL_BUFFER):
		rollbuffering += 1

func decreaseAttackBuffering():
	if (attackbuffering > 0):
		attackbuffering -= 1

func decreaseRollBuffering():
	if (rollbuffering > 0):
		rollbuffering -= 1

func useStaminaAttack():
	stats.stamina -= staminaPerAttack
	stats.regenOn = false

func useStaminaRoll():
	stats.stamina -= staminaPerRoll
	stats.regenOn = false

func move():
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)
	hurtbox.create_hitEffect()
