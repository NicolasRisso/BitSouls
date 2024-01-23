extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var sprite = $Sprite
onready var hitboxPivot = $HitboxPivot

var direction : Vector2

func _ready():
	set_physics_process(false)

func _process(_delta):
	direction = player.position - position
	
	if direction.x < 0:
		sprite.flip_h = true
		#hitboxPivot.rotation_degrees = 0
	else:
		sprite.flip_h = false
	hitboxPivot.rotation_degrees = 180 + round(rad2deg(atan2(direction.y, direction.x)))

func _physics_process(delta):
	var velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
