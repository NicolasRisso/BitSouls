extends State

var can_transition: bool = false

func enter():
	set_physics_process(true)
	play_animation("LaserShowCast")

func play_animation(anim_name):
	animation_player.play(anim_name)
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
	
func anim_laserCast_ended():
	play_animation("LaserShow")

func anim_laser_ended():
	can_transition = true
