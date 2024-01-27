extends TextureProgress

onready var label = $Label

var max_Health = 0

func set_bar(value):
	self.value = value
	
func _ready():
	PlayerStats.connect("died", self, "hideBar")
	max_value = max_Health
	value = max_Health
	
func connect_boss_healthBar(boss):
	boss.connect("health_changed", self, "set_bar")
	visible = true
	max_value = boss.maxHealth
	value = boss.health
	label.text = boss.name

func hideBar():
	self.visible = false
