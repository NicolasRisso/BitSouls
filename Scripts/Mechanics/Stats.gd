extends Node

export(float) var max_health = 100
export(float) var damage = 10

onready var health = max_health setget set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0: emit_signal("no_health")

#Encontra a hitbox e salva o dano nela
func _ready():
	var hitbox = get_node_or_null("../Hitbox")
	if !hitbox: hitbox = get_node_or_null("../HitboxPivot/Hitbox")
	if hitbox: hitbox.damage = damage
	print(hitbox)
