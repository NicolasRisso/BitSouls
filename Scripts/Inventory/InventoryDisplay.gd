extends GridContainer

export(Resource) var inventory

func _ready():
	for i in range(get_child_count()):
		if (get_child(i) is CenterContainer):
			get_child(i).setInventory(inventory)
		
	inventory.displayRect = rect_min_size
	inventory.connect("items_changed", self, "_on_itens_changed")
	inventory.make_items_unique()
	update_inventory_display()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	if (item_index > inventory.items.size() - 1): return
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

func _on_itens_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item, inventory)
