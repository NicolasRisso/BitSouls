extends State

var can_transition: bool = false

func enter():
	set_physics_process(true)
	animation_player.play("Block")

func transition():
	if can_transition:
		can_transition = false
		if owner.direction.length() <= 50:
			get_parent().change_state("ForceField")
		else:
			get_parent().change_state("Dash")
			
func animation_ended():
	can_transition = true
