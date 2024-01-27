extends State

var can_transition: bool = false

onready var bugTimer : Timer = $BugTimer

func enter():
	set_physics_process(true)
	play_animation("ForceField")
	bugTimer.wait_time = 3
	bugTimer.start()
	
func exit():
	set_physics_process(false)
	owner.set_physics_process(false)
	bugTimer.stop()

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
	bugTimer.stop()


func _on_BugTimer_timeout():
	if randf() <= 0.5:
		get_parent().change_state("HomingMissile")
	else:
		get_parent().change_state("LaserBeam")
