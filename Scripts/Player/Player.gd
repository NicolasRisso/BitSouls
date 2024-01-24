extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK,
	USE,
	INVENTORY
}

export(Resource) var equipment
#MOVEMENT
export var ACCELERATION = 1000
export var FRICTION = 500 #MAX_SPEED = 80, 75, 70, 35
#ROLL
export var AFTER_ROLL_MOMENTUM = 0.5
#INVINCIBILITY DURATION
export(int) var MAX_ATTACK_BUFFER = 1
export(int) var MAX_ROLL_BUFFER = 1
export(int) var MAX_HEAL_BUFFER = 1
#STAMINA CONSUPTION
export(int) var staminaPerAttack = 15
export(int) var staminaPerRoll = 30
#HEALING
export(int) var maxHealingPotions = 5

export(NodePath) var inventoryContainer_path
export(NodePath) var inventoryUI_path

const PlayerHurtSound = preload("res://prefabs/PlayerHurtSound.tscn")

var state = MOVE

var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
var knockbackVector = Vector2.ZERO

var respawnPoint = Vector2.ZERO

var stats = PlayerStats

var usesLeft = 0
var healAmmount = 0

var KNOCKBACK_FORCE = 0

var attackbuffering = 0
var rollbuffering = 0
var healBuffering = 0

var bonusFireGreaseDamage = 0
var bonusGreaseDuration = 0

var healCounted = false
var isDrinkable = false

var fireGrease = false

var fullscreen = true
var inventory = false
var reading = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimation
onready var animationState = animationTree.get("parameters/playback")
onready var inventoryContainer = get_node(inventoryContainer_path)
onready var inventoryUI = get_node(inventoryUI_path)
onready var itemBox = $ItemBox
onready var hitbox = $HitboxPivot/Hitbox

func _ready():
	if equipment is Inventory:
		equipment.connect("items_changed", self, "_updateItemStats")
	_updateItemStats([])
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	stats.connect("no_health", self, "reloadScene")
	stats.connect("update_hitbox", self, "_update_hitbox")
	Signals.connect("lostTotemInteracted", self, "refreashArea")
	Signals.connect("signInteract", self, "setReading")
	animationTree.active = true
	PlayerStats.itemRead()
	_update_hitbox()
	respawnPoint = position

func _updateItemStats(indexes):
	if equipment is Inventory:
		var tmp = equipment.items[5]
		if tmp is Usable:
			if tmp.usableType == Usable.UsableType.HEAL:
				usesLeft = equipment.items[5].amount
				healAmmount = equipment.items[5].healAmount
				isDrinkable = equipment.items[5].drinkable
				fireGrease = false
				bonusFireGreaseDamage = 0
				bonusGreaseDuration = 0
			elif tmp.usableType == Usable.UsableType.BUFF:
				fireGrease = true
				if (tmp is Grease):
					bonusFireGreaseDamage = tmp.bonusFireDamage
					bonusGreaseDuration = tmp.bonusDuration
				usesLeft = tmp.amount
			else:
				fireGrease = false
				bonusFireGreaseDamage = 0
				bonusGreaseDuration = 0
				usesLeft = 0
		else: usesLeft = 0
	else: usesLeft = 0

func _physics_process(delta):
	knockbackVector = knockbackVector.move_toward(Vector2.ZERO, KNOCKBACK_FORCE * delta)
	knockbackVector = move_and_slide(knockbackVector)
	
	bufferRead()
	match state:
		MOVE:
			move_state(delta)
			states()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		USE:
			heal_state()
		INVENTORY:
			inventory_state()

func states():
	if (attackbuffering > 0): state = ATTACK
	if (rollbuffering > 0): state = ROLL
	if (healBuffering > 0): state = USE
	
func bufferRead():
	if Input.is_action_just_pressed("FullScreen"):
		fullscreen = !fullscreen
		OS.set_window_fullscreen(fullscreen)
	if Input.is_action_just_pressed("inventory") or (Input.is_action_just_pressed("close") and inventory):
		inventory = !inventory
		inventoryContainer.visible = inventory
		inventoryUI.visible = !inventory
		PlayerStats.emitInventoryUpdate()
		if(!inventory): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("close") and reading:
		Signals.emit_signal("signInteract", [false, ""])
		
	if inventory or reading: return
	if Input.is_action_just_pressed("attack") and stats.stamina >= staminaPerAttack:
		increaseAttackBuffering()
	if Input.is_action_just_pressed("roll") and stats.stamina >= staminaPerRoll:
		increaseRollBuffering()
	if Input.is_action_just_pressed("heal") and usesLeft > 0:
		increaseHealBuffering()
	if Input.is_action_just_pressed("grab_item"):
		itemBox.enableForTime(0.1)
		

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
		animationTree.set("parameters/Heal/blend_position", input_vector)
		animationTree.set("parameters/Eat/blend_position", input_vector)
		animationTree.set("parameters/FireAttack/blend_position", input_vector)
		animationTree.set("parameters/FireGrease/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * PlayerStats.maxSpeed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()

func inventory_state():
	velocity = Vector2.ZERO
	
func setReading(values):
	reading = values[0]

func heal_state():
	velocity = Vector2.ZERO
	if (fireGrease): animationState.travel("FireGrease")
	elif (isDrinkable): animationState.travel("Heal")
	else: animationState.travel("Eat")

func attack_state():
	velocity = Vector2.ZERO
	setInAnimation(true)
	if (stats.damage > stats.fireDamage) and !stats.greaseBuffed: animationState.travel("Attack")
	else: animationState.travel("FireAttack")

func roll_state():
	velocity = rollVector * stats.rollSpeed 
	setInAnimation(true)
	animationState.travel("Roll")
	hurtbox.start_invincibility(PlayerStats.rollInvulnerabilityDuration)
	blinkAnimationPlayer.play("Stop")
	move()
	
func attack_animation_finished():
	state = MOVE
	setInAnimation(false)
	healCounted = false
	
func roll_animation_finished():
	velocity *= AFTER_ROLL_MOMENTUM
	setInAnimation(false)
	state = MOVE

func increaseHealBuffering():
	if (healBuffering < MAX_HEAL_BUFFER):
		healBuffering += 1

func increaseAttackBuffering():
	if (attackbuffering < MAX_ATTACK_BUFFER):
		attackbuffering += 1

func increaseRollBuffering():
	if (rollbuffering < MAX_ROLL_BUFFER):
		rollbuffering += 1

func decreaseHealBuffering():
	if (healBuffering > 0):
		healBuffering -= 1
	if (!healCounted):
		usesLeft -= 1
		healCounted = true
		if equipment is Inventory:
			if equipment.items[5] is Potion or equipment.items[5] is Grease:
				equipment.items[5].amount = usesLeft
				equipment.emit_signal("items_changed", [5])

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

func startHealing():
	stats.heal(healAmmount)

func startGrease():
	if (equipment.items[5] is Grease):
		PlayerStats.callGreaseTimer(bonusFireGreaseDamage, bonusGreaseDuration)

func setInAnimation(value):
	stats.inAnimation = value
	
func move():
	velocity = move_and_slide(velocity)

func reloadScene():
	PlayerStats.refreash()
	position = respawnPoint

func refreashArea():
	PlayerStats.refreash()

func knockback(area):
	var direction = (position - area.owner.position).normalized()
	KNOCKBACK_FORCE = area.knockbackForce
	knockbackVector = direction * area.knockbackSpeed

func _update_hitbox():
	hitbox.damage = stats.damage
	hitbox.armorPierce = stats.armorPierce
	hitbox.fireDamage = stats.fireDamage
	hitbox.firePierce = stats.fireArmorPierce

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage * (1 - stats.physicalDamageNegation + area.armorPierce)
	stats.health -= area.fireDamage * (1 - stats.fireDamageNegation + area.firePierce)
	if area.triggerInvincibility: hurtbox.start_invincibility(0.35)
	hurtbox.create_hitEffect(area.damage, area.fireDamage)
	knockback(area)
	if (stats.health <= 0):
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invencibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_Hurtbox_invencibility_started():
	if(state != ROLL):
		blinkAnimationPlayer.play("Start")
