extends State

var can_transition: bool = false

export(PoolRealArray) var dash_duration = PoolRealArray([0.35, 0.8])
export(PoolRealArray) var distance_adjustment = PoolRealArray([30, 130])

onready var timer: Timer = $Timer

func enter():
	set_physics_process(true)
	can_transition = false
	animation_player.play("Glowing")
	dash()
	
func dash():
	var tween = create_tween()
	var dash_time = get_dash_duration_based_on_distance()
	tween.tween_property(owner, "position", player.position, dash_time)
	timer.wait_time = dash_time
	timer.start()
	
func get_dash_duration_based_on_distance() -> float:
	var distance = player.global_position.distance_to(global_position)
	var t = clamp((distance - distance_adjustment[0]) / (distance_adjustment[1] - distance_adjustment[0]), 0, 1)
	return lerp(dash_duration[0], dash_duration[1], t)

func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("Follow")


func _on_Timer_timeout():
	can_transition = true
