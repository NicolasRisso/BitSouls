extends GridContainer

export(Resource) var inventory
export var isMainInventory : bool = false

const SLOTS_PER_ROW = 5
var max_slots = 20
var slot_prefab = preload("res://prefabs/Itens/InventorySlotDisplay.tscn")

func _ready():
	for i in range(get_child_count()):
		if (get_child(i) is CenterContainer):
			get_child(i).setInventory(inventory)
		
	inventory.displayRect = rect_min_size
	inventory.connect("items_changed", self, "_on_itens_changed")
	if isMainInventory: inventory.connect("item_setted", self, "adjust_slots_late")
	if isMainInventory: inventory.connect("inventory_opened", self, "adjust_slots_late")
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

func adjust_slots_late():
	call_deferred("ajust_slots")

func ajust_slots():
	var slots_atuais = get_child_count()
	var fileiras_atuais = slots_atuais / SLOTS_PER_ROW
	var canDeleteLastRow = false
	var canCreateNewRow = false

	canDeleteLastRow = verify_last_10_empty()
	
	for i in range(slots_atuais - SLOTS_PER_ROW, slots_atuais):
		if slot_esta_ocupado(i):
			canCreateNewRow = true
			break
	
	print(str(canCreateNewRow) + ", " + str(canDeleteLastRow))

	if canDeleteLastRow and inventory.items.size() > 20:
		delete()
	
	if canCreateNewRow:
		print("CREATE")
		inventory.add_new_slots(5)
		for i in range(SLOTS_PER_ROW):
			var slot = slot_prefab.instance()
			slot.setInventory(inventory)
			add_child(slot)
			slot.itemAmountLabel.text = ""
		print("size: " + str(inventory.items.size()))

func verify_last_10_empty():
	for i in range(inventory.items.size() - (2 * SLOTS_PER_ROW), inventory.items.size()):
		if slot_esta_ocupado(i):
			return false
		elif inventory.items.size() > 20: return true

func slot_esta_ocupado(slot_index):
	if slot_index < inventory.items.size():
		return inventory.items[slot_index] is Item
	return false
	
func delete():
	print("DELETE")
	for i in range(SLOTS_PER_ROW):
		var ultimo_slot = get_child(inventory.items.size() - i - 1)
		ultimo_slot.queue_free()
	inventory.remove_newest_slots(5)
	if verify_last_10_empty() and inventory.items.size() > 20: delete()
