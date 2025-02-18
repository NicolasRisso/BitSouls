extends Area2D

export(bool) var showHit = true
export(Vector2) var offset = Vector2(0, 8)

const hitEffect = preload("res://prefabs/Effects/HitEffect.tscn")
const fireHitEffect = preload("res://prefabs/Effects/FireHitEffect.tscn")

onready var timer = $Timer

var invincible = false setget set_invincible

signal invencibility_started
signal invencibility_ended

func create_hitEffect(damage, fireDamage):
	if !showHit: return
	if (damage + fireDamage <= 0): return
	var effect
	if damage > fireDamage:
		effect = hitEffect.instance()
	else:
		effect = fireHitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position - offset

func start_invincibility(duration):
	if(duration > 0):
		self.invincible = true
		timer.start(duration)

func set_invincible(value):
	invincible = value
	if invincible: 
		emit_signal("invencibility_started")
	else:
		emit_signal("invencibility_ended")

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invencibility_started():
	set_deferred("monitoring", false)

func _on_Hurtbox_invencibility_ended():
	monitoring = true
