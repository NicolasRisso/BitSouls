extends Label

export(bool) var usePercentage = false
export(bool) var useTwoVariables = false
export(String, "ItemChanged,HealthChanged,StaminaChanged") var typeOfUpdate = "ItemChanged"
export(String) var textBase = ""
export(String, "damage,armorPierce,physicalDamageNegation,health,max_health_with_buffs,stamina,max_stamina,weight,max_weight,fireDamage,fireArmorPierce,fireDamageNegation") var selectedVariable : String = "physicalDamageNegation"
export(String, "damage,armorPierce,physicalDamageNegation,health,max_health_with_buffs,stamina,max_stamina,weight,max_weight,fireDamage,fireArmorPierce,fireDamageNegation") var selectedVariable2 : String = "physicalDamageNegation"

const equipment = preload("res://prefabs/Itens/Equipment.tres")
const extraSword = preload("res://prefabs/Itens/ExtraSword.tres")
const extraUsable = preload("res://prefabs/Itens/ExtraUsable.tres")
const artifacts = preload("res://prefabs/Itens/Artifacts.tres")

func _ready():
	if (typeOfUpdate == "ItemChanged"):
		equipment.connect("items_changed", self, "_updateText")
		extraSword.connect("items_changed", self, "_updateText")
		extraUsable.connect("items_changed", self, "_updateText")
		artifacts.connect("items_changed", self, "_updateText")
	elif (typeOfUpdate == "HealthChanged"):
		PlayerStats.connect("health_changed", self, "_updateText")
	elif (typeOfUpdate == "StaminaChanged"):
		PlayerStats.connect("stamina_changed", self, "_updateText")
	_updateText([])

func _updateText(_indexes):
	if (!(selectedVariable in PlayerStats)): return
	if (useTwoVariables):
		text = textBase + str(PlayerStats[selectedVariable]).pad_decimals(2) + "/" + str(PlayerStats[selectedVariable2])
	else:
		if (usePercentage): text = textBase + str(PlayerStats[selectedVariable] * 100) + "%"
		else: text = textBase + str(PlayerStats[selectedVariable]).pad_decimals(2)
