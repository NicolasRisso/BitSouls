extends CenterContainer

export(Resource) var equipment
export(int) var item_index = -1

onready var textureRect = $ItemTextureRect
onready var label = $ItemTextureRect/ItemAmount

func _ready():
	equipment.connect("items_changed", self, "_updateUI")
	_updateUI([])

func _updateUI(_indexes):
	if item_index != -1:
		var tmp = equipment.items[item_index]
		if tmp is Item:
			textureRect.texture = tmp.texture
			if (tmp.isStackable):
				label.text = str(equipment.items[item_index].amount)
			return
	textureRect.texture = null
	label.text = ""
