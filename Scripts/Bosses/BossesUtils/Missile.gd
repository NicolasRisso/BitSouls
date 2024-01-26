extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var player = get_parent().get_parent().find_node("Player")
onready var canHitBoss : bool = true
onready var delayToHitBoss : float = 1.5

onready var hitBossDelayTimer = $HitBossDelay
onready var hitboxBoss = $Hitbox2/CollisionShape2D2

export var explosionEffect: PackedScene

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready():
	hitBossDelayTimer.wait_time = delayToHitBoss
	hitBossDelayTimer.start()

func _physics_process(delta):
	acceleration = (player.position - position).normalized() * 700
	
	velocity += acceleration * delta
	rotation = velocity.angle()
	
	velocity = velocity.limit_length(150)
	
	position += velocity * delta

func _on_Hitbox_area_entered(area):
	explode()

func _on_Timer_timeout():
	explode()
	
func explode():
	call_deferred("_destroy_self")

func _destroy_self():
	var _explosionEffect = explosionEffect.instance()
	get_tree().current_scene.add_child(_explosionEffect)
	_explosionEffect.global_position = global_position
	queue_free()

func _on_HitBossDelay_timeout():
	hitboxBoss.disabled = false
