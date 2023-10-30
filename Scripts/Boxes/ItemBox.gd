extends Area2D

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var inventory = preload("res://prefabs/Itens/Inventory.tres")

func enableForTime(duration):
	timer.start(duration)
	collisionShape.disabled = false

func _on_Timer_timeout():
	collisionShape.disabled = true

func _on_ItemBox_area_entered(area):
	var index = inventory.get_first_slot_available()
	if index != -1:
		inventory.set_item(index, area.item, inventory)
		area.destroy()
