extends Node

export(float) var max_health = 100.0
export(float) var damage = 10.0
export(float) var armorPierce = 0
export(float) var max_stamina = 100.0
export(float) var staminaRegenDelay = 1.0
export(float) var staminaRegenPerSecond = 45.0
export(float) var physicalDamageNegation = 0.2
export(float) var max_weight = 50
export(PoolRealArray) var rollInvulnerability = PoolRealArray([0.5, 0.35, 0.2])
export(PoolRealArray) var speedAdjustment = PoolRealArray([80, 75, 70, 35])
export(PoolRealArray) var rollSpeedAdjustment = PoolRealArray([90, 82.25, 75, 45])
export(bool) var useEquipment = false
export(bool) var useStamina = false
export(bool) var useHealling = false
export(float) var HealVelocity = 1.5
export(Resource) var equipment

var extraSword = preload("res://prefabs/Itens/ExtraSword.tres")
var extraUsable = preload("res://prefabs/Itens/ExtraUsable.tres")

onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina
onready var weight = 0 setget set_weight

onready var timer = $Timer

var regenOn = false
var waitingTimer = false
var healRegenOn = false

var rollInvulnerabilityDuration = 0
var maxSpeed = 0
var rollSpeed = 0
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
	if (value > max_health):
		health = max_health
	else:
		health = value
	emit_signal("health_changed", health)
	if health <= 0: emit_signal("no_health")

func set_stamina(value):
	if (value > max_stamina):
		stamina = max_stamina
		regenOn = false
	else:
		stamina = value
	callStaminaRegen()
	emit_signal("stamina_changed", stamina)
	if(stamina > max_stamina):
		regenOn = false

func set_weight(value):
	weight = value
	adjustRoll()

func adjustRoll():
	if weight <= 0.3 * max_weight:
		rollInvulnerabilityDuration = rollInvulnerability[0]
		maxSpeed = speedAdjustment[0]
		rollSpeed = rollSpeedAdjustment[0]
	elif weight > 0.3 * max_weight and weight <= 0.7 * max_weight:
		rollInvulnerabilityDuration = rollInvulnerability[1]
		maxSpeed = speedAdjustment[1]
		rollSpeed = rollSpeedAdjustment[1]
	elif weight > 0.7 * max_weight and weight <= max_weight:
		rollInvulnerabilityDuration = rollInvulnerability[2]
		maxSpeed = speedAdjustment[2]
		rollSpeed = rollSpeedAdjustment[2]
	else:
		rollInvulnerabilityDuration = 0.0
		maxSpeed = speedAdjustment[3]
		rollSpeed = rollSpeedAdjustment[3]
		
#Encontra a hitbox e salva o dano nela
func _ready():
	if useEquipment:
		physicalDamageNegation = 0
		adjustRoll()
	if equipment is Inventory and useEquipment:
		equipment.connect("items_changed", self, "_updateItemStats")
		extraSword.connect("items_changed", self, "_updateItemStats")
		extraUsable.connect("items_changed", self, "_updateItemStats")
	_updateItemStats([])
	
func _updateItemStats(indexes):
	itemRead()
	var hitbox = get_node_or_null("../Hitbox")
	if !hitbox: hitbox = get_node_or_null("../HitboxPivot/Hitbox")
	if hitbox:
		hitbox.damage = damage
		hitbox.armorPierce = armorPierce

func itemRead():
	if equipment is Inventory and useEquipment:
		if equipment.items[0] is Sword:
			damage = equipment.items[0].damage
			if (damage < 1): damage = 1
			armorPierce = equipment.items[0].armorPierce
		else:
			damage = 1
			armorPierce = 0
			
		var totalDamageNegation = 0
		if equipment.items[1] is Helmet:
			totalDamageNegation += equipment.items[1].damageNegation
		if equipment.items[2] is Chestplate:
			totalDamageNegation += equipment.items[2].damageNegation
		if equipment.items[3] is Gloves:
			totalDamageNegation += equipment.items[3].damageNegation
		if equipment.items[4] is Boots:
			totalDamageNegation += equipment.items[4].damageNegation
		physicalDamageNegation = totalDamageNegation
		
		var totalWeight = 0
		for i in range(equipment.items.size()):
			if equipment.items[i] is Item:
				totalWeight += equipment.items[i].weight
		for i in range(extraSword.items.size()):
			if extraSword.items[i] is Item:
				totalWeight += extraSword.items[i].weight
		for i in range(extraUsable.items.size()):
			if extraUsable.items[i] is Item:
				totalWeight += extraUsable.items[i].weight
		self.weight = totalWeight

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
