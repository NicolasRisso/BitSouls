extends Label

export(bool) var usePercentage = false
export(bool) var useTwoVariables = false
export(String, "ItemChanged,HealthChanged,StaminaChanged") var typeOfUpdate = "ItemChanged"
export(String) var textBase = ""
export(String, "damage,armorPierce,physicalDamageNegation,health,max_health,stamina,max_stamina,weight,max_weight") var selectedVariable : String = "physicalDamageNegation"
export(String, "damage,armorPierce,physicalDamageNegation,health,max_health,stamina,max_stamina,weight,max_weight") var selectedVariable2 : String = "physicalDamageNegation"

var equipment = preload("res://prefabs/Itens/Equipment.tres")

func _ready():
	if (typeOfUpdate == "ItemChanged"):
		equipment.connect("items_changed", self, "_updateText")
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
		else: text = textBase + str(PlayerStats[selectedVariable])
