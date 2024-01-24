extends State

onready var collision = $"../../PlayerDetection/CollisionShape2D"

var player_entered : bool = false setget set_player_entered

func set_player_entered(value):
	player_entered = value
	collision.set_deferred("disabled", value)

func transition():
	if player_entered:
		get_parent().change_state("Follow")


func _on_PlayerDetection_body_entered(body):
	player_entered = true
	get_parent().get_parent().callHealthBar()
