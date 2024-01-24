extends TextureProgress

var max_Health = 0

func set_bar(value):
	self.value = value
	
func _ready():
	max_value = max_Health
	value = max_Health
	
func connect_boss_healthBar(boss):
	boss.connect("health_changed", self, "set_bar")
	visible = true
	max_value = boss.maxHealth
	value = boss.health
