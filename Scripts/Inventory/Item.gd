extends Resource
class_name Item

enum ItemType{
	SWORD,
	USABLE,
	HELMET,
	CHESTPLATE,
	GLOVES,
	SHOES,
	ARTIFACT,
	ALL
}

export(String) var name = ""
export(String) var description = ""
export(Texture) var texture
export(ItemType) var type = ItemType.ALL

export(bool) var isStackable = false
export(int) var amount = 1

export(float) var weight = 0.0
