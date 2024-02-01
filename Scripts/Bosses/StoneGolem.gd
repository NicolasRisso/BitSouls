extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var healthBar = get_tree().current_scene.get_node("CanvasLayer").find_node("BossHealthBar")
onready var slainedMessage = get_tree().current_scene.get_node("CanvasLayer").find_node("AgonizedSoulContained")
onready var sprite = $Sprite
onready var hitboxPivot = $HitboxPivot
onready var hurtbox = $Hurtbox

export var boss_path = "res://prefabs/Bosses/StoneGolem.tscn"
export(float) var maxHealth = 500
onready var health : float = maxHealth setget set_health
export(float) var physicalArmor = 0.3
export(float) var physicalArmorBuff = 0.2
export(float) var fireArmor = 0.15
export(float) var fireArmorBuff = 0.7
export(float) var blockDamageNegation = 0.75
export(int) var movementsBeforeOverload = 20

var movs : int = 0

var armorBuffed : bool = false
var alreadyArmorBuffed : bool = false
var isAlive : bool = true
var is_blocking : bool = false
var overloadIncoming : bool = false

var originalPos : Vector2
var direction : Vector2

signal health_changed(value)
signal death

func _ready():
	if name != "Stone Golem": queue_free()
	set_physics_process(false)
	slainedMessage.boss_conection(self)
	PlayerStats.connect("no_health", self, "reloadScene")
	originalPos = position

func _process(_delta):
	if !isAlive: return
	direction = player.position - position
	
	if direction.x < 0:
		sprite.flip_h = true
		#hitboxPivot.rotation_degrees = 0
	else:
		sprite.flip_h = false
		
func aim_attack():
	hitboxPivot.rotation_degrees = 180 + round(rad2deg(atan2(direction.y, direction.x)))

func _physics_process(delta):
	var velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
	if (movs >= movementsBeforeOverload):
		movs = 0
		overloadIncoming = true
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0 and isAlive:
		find_node("FiniteStateMachine").change_state("Death")
		emit_signal("death")
		Signals.emit_signal("bossDefeated")
		isAlive = false
	elif health <= maxHealth / 2:
		if !alreadyArmorBuffed:
			armorBuffed = true

func callHealthBar():
	healthBar.connect_boss_healthBar(self)

func is_blocking(value : bool):
	is_blocking = value

func _on_Hurtbox_area_entered(area):
	if !isAlive: return
	var damage_multi = 1
	if is_blocking: damage_multi = 1 - blockDamageNegation
	var damageNegation = 1 - physicalArmor + area.armorPierce
	if (damageNegation > 1): damageNegation = 1
	self.health -= area.damage * (damageNegation) * damage_multi
	self.health -= area.fireDamage * (1 - fireArmor + area.firePierce) * damage_multi
	hurtbox.create_hitEffect(area.damage, area.fireDamage)
	
func overloadPlayed():
	overloadIncoming = false
	
func armorBuffEffect():
	physicalArmor += physicalArmorBuff
	fireArmor += fireArmorBuff
	alreadyArmorBuffed = true
	armorBuffed = false
	
func did_movement():
	movs += 1
	print(movs)
	
func reloadScene():
	call_deferred("createNewBoss")

func createNewBoss():
	self.name = "oldBoss"
	var new_boss = load(boss_path).instance()
	new_boss.position = originalPos
	get_parent().add_child(new_boss)
	queue_free()
