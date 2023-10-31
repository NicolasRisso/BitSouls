extends Node2D

export(int) var item_index = 0
export(String) var input_action_name = "change_sword" 

onready var extraInventory = get_parent().inventory
onready var equipment = preload("res://prefabs/Itens/Equipment.tres")

func _process(_delta):
	if PlayerStats.inAnimation: return
	if Input.is_action_just_pressed(input_action_name):
		var my_item = equipment.items[item_index]
		var target_item = extraInventory.items[0]
		equipment.swap_itens(item_index, equipment, 0, extraInventory)
		equipment.set_item(item_index, target_item, equipment)
		target_item = extraInventory.items[0]
		equipment.swap_itens(1, extraInventory, 0, extraInventory)
		equipment.set_item(1, target_item, extraInventory)
