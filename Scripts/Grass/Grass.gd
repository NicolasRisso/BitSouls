extends Node2D

const GrassEffect = preload("res://prefabs/Effects/GrassEffect.tscn")

var originalPos = Vector2.ZERO

func _ready():
	PlayerStats.connect("died", self, "respawn")
	originalPos = position

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	self.visible = false
	position = Vector2(-100, 100)

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	
func respawn():
	self.visible = true
	position = originalPos
