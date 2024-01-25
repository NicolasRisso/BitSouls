extends State

onready var pivot = $"../../Pivot"
onready var tween = $Tween

var can_transition: bool = false

export(float) var chanceLongLaser = 0.25

func enter():
	set_physics_process(true)
	play_animation("LaserCast")

func play_animation(anim_name):
	animation_player.play(anim_name)
	
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()
	
func set_target_again(delay : float):
	var target_angle = (owner.direction - pivot.position).angle()
	tween.interpolate_property(pivot, "rotation", pivot.rotation, target_angle, delay, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
	
func anim_laserCast_ended():
	if randf() <= chanceLongLaser:
		play_animation("LongLaser")
	else:
		play_animation("Laser")

func anim_laser_ended():
	can_transition = true
