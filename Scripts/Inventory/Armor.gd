extends Item
class_name Armor

enum ArmorType {
	HELMET,
	CHESTPLATE,
	GLOVES,
	BOOTS
}

export(ArmorType) var armorType = ArmorType.HELMET
