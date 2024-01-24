extends State

var can_transition: bool = false
export var dash_duration: float = 0.8

onready var timer: Timer = $Timer

func enter():
	set_physics_process(true)
	can_transition = false
	animation_player.play("Glowing")
	dash()
	
func dash():
	var tween = create_tween()
	tween.tween_property(owner, "position", player.position, dash_duration)
	timer.wait_time = 0.8
	timer.start()

func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("Follow")


func _on_Timer_timeout():
	can_transition = true
