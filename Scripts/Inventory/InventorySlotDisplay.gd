extends CenterContainer

var inventory

const selectedItemTexts = preload("res://prefabs/UI/SelectedItem.tres")

export(Item.ItemType) var type_acceptable = Item.ItemType.ALL
export(Texture) var formatTexture = null

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/Node2D/ItemAmount

func setInventory(invent):
	inventory = invent

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		if (item.isStackable): itemAmountLabel.text = str(item.amount)
		else: itemAmountLabel.text = ""
	else:
		if (formatTexture is Texture):
			itemTextureRect.texture = formatTexture
		else: itemTextureRect.texture = load("res://Art/Itens/EmptyInventorySlot.png")
		itemAmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index, inventory)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.inventory = inventory
		data.originalSlotType = type_acceptable
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		
		selectedItemTexts.name = item.name
		selectedItemTexts.description = item.description
		
		#print(selectedItemTexts.name + " | " + selectedItemTexts.description)
		
		set_drag_preview(dragPreview)
		
		inventory.drag_data = data
		return data

func can_drop_data(position, data):
	if data is Dictionary and data.has("item"):
		if data.item.type == type_acceptable or type_acceptable == Item.ItemType.ALL:
			if inventory.items[get_index()] is Item:
				if inventory.items[get_index()].type == data.originalSlotType or data.originalSlotType == Item.ItemType.ALL:
					return true
			else: return true
	return false

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.name == data.item.name and my_item.isStackable:
		my_item.amount += data.item.amount
		print(my_item.amount)
		print(data.item.amount)
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		inventory.swap_itens(my_item_index, inventory, data.item_index, data.inventory)
		inventory.set_item(my_item_index, data.item, inventory)
	inventory.drag_data = null
	data.inventory.drag_data = null
