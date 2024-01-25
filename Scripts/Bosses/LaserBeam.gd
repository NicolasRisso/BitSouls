extends State

onready var pivot = $"../../Pivot"
var can_transition: bool = false

export(float) var chanceLongLaser = 0.25

func enter():
	set_physics_process(true)
	play_animation("LaserCast")

func play_animation(anim_name):
	animation_player.play(anim_name)
	
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()
	
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
