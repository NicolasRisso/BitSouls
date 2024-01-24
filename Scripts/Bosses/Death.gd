extends State

func enter():
	set_physics_process(true)
	animation_player.play("Death")
	
