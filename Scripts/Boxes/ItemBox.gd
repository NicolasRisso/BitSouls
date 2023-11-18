extends Area2D

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D
onready var player = get_parent()

var inventory = preload("res://prefabs/Itens/Inventory.tres")

func enableForTime(duration):
	timer.start(duration)
	collisionShape.disabled = false

func _on_Timer_timeout():
	collisionShape.disabled = true

func _on_ItemBox_area_entered(area):
	#TOTEM
	if area.get_collision_mask_bit(7) == true:
		player.respawnPoint = area.respawnPosition
	#SIGN
	elif area.get_collision_mask_bit(8) == true:
		print(area.text)
	#ITEM
	else:
		var index = inventory.get_first_slot_available()
		if index != -1:
			inventory.set_item(index,area.item, inventory)
			area.destroy()
