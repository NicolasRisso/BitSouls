extends TextureProgress

var max_Health = PlayerStats.max_health_with_buffs

const artifacts = preload("res://prefabs/Itens/Artifacts.tres")

func set_bar(value):
	self.value = value
	max_value = PlayerStats.max_health_with_buffs
	
func _ready():
	PlayerStats.connect("health_changed", self, "set_bar")
	artifacts.connect("items_changed", self, "set_max_bar")
	max_value = max_Health
	value = max_Health
