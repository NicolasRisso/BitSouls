extends Camera2D

export(NodePath) onready var player = get_node(player)

var game_size := Vector2(320, 180)
onready var window_scale := (OS.window_size / game_size).x
onready var actual_cam_pos := global_position

func _process(delta):
	var cam_pos = player.global_position;
	actual_cam_pos = lerp(actual_cam_pos, cam_pos, delta * 5)
	
	var subpixel_position = actual_cam_pos.round() - actual_cam_pos
	
	Singleton.viewport_container.material.set_shader_param("cam_offset", subpixel_position)
	
	global_position = actual_cam_pos.round()
