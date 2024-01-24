extends State

var can_transition: bool = false

func enter():
	set_physics_process(true)
	play_animation("ForceField")

func play_animation(anim_name):
	animation_player.play(anim_name)
	
func transition():
	if can_transition:
		can_transition = false
		if randf() <= 0.5:
			get_parent().change_state("HomingMissile")
		else:
			get_parent().change_state("LaserBeam")

func anim_ended():
	can_transition = true
