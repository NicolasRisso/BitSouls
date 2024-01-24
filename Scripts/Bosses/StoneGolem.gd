extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var healthBar = get_tree().current_scene.get_node("CanvasLayer").find_node("BossHealthBar")
onready var sprite = $Sprite
onready var hitboxPivot = $HitboxPivot
onready var hurtbox = $Hurtbox

export(float) var maxHealth = 500
onready var health : float = maxHealth setget set_health
export(float) var physicalArmor = 0.3
export(float) var physicalArmorBuff = 0.2
export(float) var fireArmor = 0.15
export(float) var fireArmorBuff = 0.7

var armorBuffed : bool = false

var direction : Vector2

signal health_changed(value)

func _ready():
	set_physics_process(false)

func _process(_delta):
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
	
func set_health(value):
	health = value
	print(health)
	emit_signal("health_changed", health)
	if health <= 0:
		find_node("FiniteStateMachine").change_state("Death")
	elif health <= maxHealth / 2:
		if !armorBuffed:
			armorBuffed = true
			physicalArmor += physicalArmorBuff
			fireArmor += fireArmorBuff
			find_node("FiniteStateMachine").change_state("ArmorBuff")

func callHealthBar():
	healthBar.connect_boss_healthBar(self)

func _on_Hurtbox_area_entered(area):
	var damageNegation = 1 - physicalArmor + area.armorPierce
	if (damageNegation > 1): damageNegation = 1
	self.health -= area.damage * (damageNegation)
	self.health -= area.fireDamage * (1 - fireArmor + area.firePierce)
	hurtbox.create_hitEffect(area.damage, area.fireDamage)
