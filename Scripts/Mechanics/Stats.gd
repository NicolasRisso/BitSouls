extends Node

export(float) var max_health = 100.0
export(float) var damage = 10.0
export(float) var armorPierce = 0
export(float) var max_stamina = 100.0
export(float) var staminaRegenDelay = 1.0
export(float) var staminaRegenPerSecond = 45.0
export(float) var physicalDamageNegation = 0.2
export(bool) var useEquipment = false
export(bool) var useStamina = true
export(bool) var useHealling = false
export(float) var HealVelocity = 1.5
export(Resource) var equipment

onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina

onready var timer = $Timer

var regenOn = false
var waitingTimer = false
var healRegenOn = false
var healLeft = 0

var totalHealled = 0

signal no_health
signal health_changed(value)
signal stamina_changed(value)

func _physics_process(delta):
	if (useHealling): heal_state(delta)	
	if !useStamina: return
	if regenOn: staminaRegen(delta)

func heal_state(delta):
	if healRegenOn:
		var tmp = healLeft * delta * HealVelocity
		if (tmp > healLeft - totalHealled): tmp = healLeft - totalHealled
		self.health += tmp
		totalHealled += tmp
		if (totalHealled >= healLeft):
			healRegenOn = false
			healLeft = 0
			totalHealled = 0

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0: emit_signal("no_health")
	if health > max_health: health = max_health

func set_stamina(value):
	stamina = value
	callStaminaRegen()
	emit_signal("stamina_changed", stamina)
	if(stamina >= max_stamina):
		regenOn = false
		stamina = max_stamina
	
#Encontra a hitbox e salva o dano nela
func _ready():
	if equipment is Inventory and useEquipment:
		equipment.connect("items_changed", self, "_updateItemStats")
	_updateItemStats([])
	
func _updateItemStats(indexes):
	if equipment is Inventory and useEquipment:
		if equipment.items[0] is Sword:
			damage = equipment.items[0].damage
			if (damage < 1): damage = 1
			armorPierce = equipment.items[0].armorPierce
		else:
			damage = 1
			armorPierce = 0

	var hitbox = get_node_or_null("../Hitbox")
	if !hitbox: hitbox = get_node_or_null("../HitboxPivot/Hitbox")
	if hitbox:
		hitbox.damage = damage
		hitbox.armorPierce = armorPierce

func callStaminaRegen():
	timer.start(staminaRegenDelay)
	waitingTimer = true

func staminaRegen(delta):
	self.stamina += staminaRegenPerSecond * delta

func heal(value):
	healLeft = value
	healRegenOn = true

func _on_Timer_timeout():
	if waitingTimer:
		regenOn = true
		waitingTimer = false
