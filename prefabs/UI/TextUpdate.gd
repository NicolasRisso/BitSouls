extends Label

export(Resource) var equipment

func _ready():
	equipment.connect("items_changed", self, "_updateText")
	_updateText([])

func _updateText(_indexes):
	text = "Damage Negation: " + str(PlayerStats.physicalDamageNegation * 100) + "%"
