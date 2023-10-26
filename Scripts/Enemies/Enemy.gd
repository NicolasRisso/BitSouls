extends KinematicBody2D

export var KNOCKBACK_FORCE = 200
export var KNOCKBACK_SPEED = 80

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

export var INVINCIBILITY_DURATION = 0.3

export var SOFT_COLLISION_MODIFIER = 400

export var TIME_RANGE = [1.0, 3.0] 

const DeathEffect = preload("res://prefabs/Effects/EnemyDeathEffect.tscn")

enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockbackVector = Vector2.ZERO
var target = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var navigationAgent = $NavigationAgent2D
onready var healthBar = $ExtraHealthBar

func _ready():
	state = pickRandomState([IDLE, WANDER])
	healthBar.stats = stats
	healthBar.loaded()

func _physics_process(delta):
	knockbackVector = knockbackVector.move_toward(Vector2.ZERO, KNOCKBACK_FORCE * delta)
	knockbackVector = move_and_slide(knockbackVector)
	
	states(delta)

	if softCollision.is_colliding():
		velocity+= softCollision.get_push_vector() * delta * SOFT_COLLISION_MODIFIER
	velocity = move_and_slide(velocity)
	
func states(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seekPlayer()
			setState(true)
		WANDER:
			setState(true)
			target = wanderController.target_position
			setTarget(delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				setState(false)
			sprite.flip_h = velocity.x < 0
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				target = player.global_position
				setTarget(delta)
			else: state = IDLE
			sprite.flip_h = velocity.x < 0

func seekPlayer():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pickRandomState(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func setState(compare):
	if wanderController.get_time_left() <= 0:
		state = pickRandomState([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(TIME_RANGE[0], TIME_RANGE[1]))
	if !compare:
		state = pickRandomState([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(TIME_RANGE[0], TIME_RANGE[1]))

func setTarget(delta):
	var direction = to_local(navigationAgent.get_next_location()).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func makePath(target):
	navigationAgent.set_target_location(target)
	
func knockback(area):
	var direction = (position - area.owner.position).normalized()
	knockbackVector = direction * KNOCKBACK_SPEED	

func _on_Hurtbox_area_entered(area):
	knockback(area)
	stats.health -= area.damage * (1 - stats.physicalDamageNegation)
	hurtbox.create_hitEffect()
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_Stats_no_health():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()


func _on_Hurtbox_invencibility_ended():
	animationPlayer.play("Stop")

func _on_Hurtbox_invencibility_started():
	animationPlayer.play("Start")


func _on_Timer_timeout():
	if (state != IDLE):
		makePath(target)
