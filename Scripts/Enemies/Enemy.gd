extends KinematicBody2D

export var KNOCKBACK_FORCE = 200
export var KNOCKBACK_SPEED = 80

var knockbackVector = Vector2.ZERO

const DeathEffect = preload("res://prefabs/Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats

func _physics_process(delta):
	knockbackVector = knockbackVector.move_toward(Vector2.ZERO, KNOCKBACK_FORCE * delta)
	knockbackVector = move_and_slide(knockbackVector)

func knockback(area):
	var direction = (position - area.owner.position).normalized()
	knockbackVector = direction * KNOCKBACK_SPEED	

func _on_Hurtbox_area_entered(area):
	knockback(area)
	stats.health -= area.damage

func _on_Stats_no_health():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
