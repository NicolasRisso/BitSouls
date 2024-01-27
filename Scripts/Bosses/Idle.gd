extends State

onready var collision = $"../../PlayerDetection/CollisionShape2D"

var player_entered : bool = false setget set_player_entered
var called_barrier_once : bool = false

func _ready():
	collision.disabled = true
	yield(get_tree().create_timer(0.1), "timeout")  # Espera 0.1 segundo
	collision.disabled = false

func set_player_entered(value):
	player_entered = value
	collision.set_deferred("disabled", value)

func transition():
	if player_entered:
		get_parent().change_state("Follow")

func _on_PlayerDetection_body_entered(body):
	player_entered = true
	if (!called_barrier_once): 
		Signals.emit_signal("startBossFight")
		called_barrier_once = true
	get_parent().get_parent().callHealthBar()
