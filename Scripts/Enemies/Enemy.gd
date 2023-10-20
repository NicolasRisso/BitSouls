extends KinematicBody2D

export var KNOCKBACK_FORCE = 200
export var KNOCKBACK_SPEED = 80

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

const DeathEffect = preload("res://prefabs/Effects/EnemyDeathEffect.tscn")

enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockbackVector = Vector2.ZERO

var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox

func _physics_process(delta):
	knockbackVector = knockbackVector.move_toward(Vector2.ZERO, KNOCKBACK_FORCE * delta)
	knockbackVector = move_and_slide(knockbackVector)
	
	states(delta)

func states(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seekPlayer()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else: state = IDLE
			sprite.flip_h = velocity.x < 0
						
	velocity = move_and_slide(velocity)

func seekPlayer():
	if playerDetectionZone.can_see_player():
		state = CHASE

func knockback(area):
	var direction = (position - area.owner.position).normalized()
	knockbackVector = direction * KNOCKBACK_SPEED	

func _on_Hurtbox_area_entered(area):
	knockback(area)
	stats.health -= area.damage
	hurtbox.create_hitEffect()

func _on_Stats_no_health():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
