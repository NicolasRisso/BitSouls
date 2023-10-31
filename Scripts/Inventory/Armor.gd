extends Item
class_name Armor

enum ArmorType {
	HELMET,
	CHESTPLATE,
	GLOVES,
	BOOTS
}

export(ArmorType) var armorType = ArmorType.HELMET
export(float) var damageNegation = 0.0
export(float) var fireDamageNegation = 0.0
