extends TextureProgress

var max_Health = PlayerStats.max_health

func set_bar(value):
	self.value = value

func _ready():
	PlayerStats.connect("health_changed", self, "set_bar")
	max_value = max_Health
	value = max_Health
