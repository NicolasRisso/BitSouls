extends TextureProgress

var max_Stamina = PlayerStats.max_stamina

func set_bar(value):
	self.value = value

func _ready():
	PlayerStats.connect("stamina_changed", self, "set_bar")
	max_value = max_Stamina
	value = max_Stamina
