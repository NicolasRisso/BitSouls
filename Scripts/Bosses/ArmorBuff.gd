extends State

var can_transition : bool = false

func enter():
	set_physics_process(true)
	animation_player.play("ArmorBuff")

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")

func animation_ended():
	can_transition = true
