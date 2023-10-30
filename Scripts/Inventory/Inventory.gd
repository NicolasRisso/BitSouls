extends Resource
class_name Inventory

var drag_data = null
var displayRect = null

signal items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
]

func set_item(item_index, item, inventory):
	var previousItem = inventory.items[item_index]
	inventory.items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previousItem
	
func remove_item(item_index, inventory):
	var previousItem = inventory.items[item_index]
	inventory.items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_itens(item_index, inventory, target_item_index, target_inventory):	
	var item = inventory.items[item_index]
	var target_item = target_inventory.items[target_item_index]
	inventory.remove_item(item_index, inventory)
	target_inventory.remove_item(target_item_index, target_inventory)
	inventory.set_item(item_index, target_item, inventory)
	target_inventory.set_item(target_item_index, item, target_inventory)
	
	emit_signal("items_changed", [item_index, target_item_index])

func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
	
func get_first_slot_available():
	for i in range (items.size()):
		if !(items[i] is Item):
			return i
	return -1
