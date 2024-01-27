extends Node2D

onready var label = $TextureProgress/Label

func _ready():
	Signals.connect("signInteract", self, "setReading")
	PlayerStats.connect("died", self, "setReading_false")
	
func setReading_false():
	setReading([false, ""])
	
func setReading(values):
	label.text = values[1]
	if values[0]:
		visible = true
	else:
		visible = false
