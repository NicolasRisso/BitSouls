extends Node2D

export(int) var wandar_range = 32

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-wandar_range, wandar_range), rand_range(-wandar_range, wandar_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.set_wait_time(duration)
	timer.start()

func _on_Timer_timeout():
	update_target_position()
