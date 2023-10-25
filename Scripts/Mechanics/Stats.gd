extends Node

export(float) var max_health = 100.0
export(float) var damage = 10.0
export(float) var max_stamina = 100.0
export(float) var staminaRegenDelay = 1.0
export(float) var staminaRegenPerSecond = 45.0
export(bool) var useStamina = true

onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina

onready var timer = $Timer

var regenOn = false
var waitingTimer = false

signal no_health
signal health_changed(value)
signal stamina_changed(value)

func _physics_process(delta):
	if !useStamina: return
	if regenOn: staminaRegen(delta)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0: emit_signal("no_health")

func set_stamina(value):
	stamina = value
	callStaminaRegen()
	emit_signal("stamina_changed", stamina)
	if(stamina >= max_stamina):
		regenOn = false
		stamina = max_stamina
	
#Encontra a hitbox e salva o dano nela
func _ready():
	var hitbox = get_node_or_null("../Hitbox")
	if !hitbox: hitbox = get_node_or_null("../HitboxPivot/Hitbox")
	if hitbox: hitbox.damage = damage
	print(hitbox)	
	
func callStaminaRegen():
	timer.start(staminaRegenDelay)
	waitingTimer = true

func staminaRegen(delta):
	self.stamina += staminaRegenPerSecond * delta

func _on_Timer_timeout():
	if waitingTimer:
		regenOn = true
		waitingTimer = false
