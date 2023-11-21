extends AnimatedSprite

func _ready():
	Signals.connect("interactArea", self, "setAnim")
	visible = false
	
func setAnim(value):
	visible = value
