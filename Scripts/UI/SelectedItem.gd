extends Label

const selectedItem = preload("res://prefabs/UI/SelectedItem.tres")

export(String, "name,description") var textType = "name"

func _ready():
	selectedItem.connect("labelChanged", self, "updateText")

func updateText():
	text = selectedItem[textType]
