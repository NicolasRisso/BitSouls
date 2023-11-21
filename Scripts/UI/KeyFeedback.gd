extends AnimatedSprite

var areaCount = 0

func _ready():
	Signals.connect("interactArea", self, "setAnim")
	visible = false
	
func setAnim(value):
	print(areaCount)
	if (value): areaCount += 1
	else: areaCount -= 1
	if areaCount > 1:
		visible = true
	else:
		visible = false
