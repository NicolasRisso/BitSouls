extends CenterContainer

var inventory

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmount

func setInventory(invent):
	inventory = invent
	print(inventory)

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		if (item.isStackable): itemAmountLabel.text = str(item.amount)
		else: itemAmountLabel.text = ""
	else:
		itemTextureRect.texture = load("res://Art/Itens/EmptyInventorySlot.png")
		itemAmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index, inventory)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.inventory = inventory
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		
		set_drag_preview(dragPreview)
		
		inventory.drag_data = data
		return data

func can_drop_data(position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.name == data.item.name and my_item.isStackable:
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		inventory.swap_itens(my_item_index, inventory, data.item_index, data.inventory)
		inventory.set_item(my_item_index, data.item, inventory)
	inventory.drag_data = null
	data.inventory.drag_data = null
