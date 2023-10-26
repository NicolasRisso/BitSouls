extends TextureProgress

var stats
var max_Health

func set_bar(value):
	self.value = value

func loaded():
	stats.connect("health_changed", self, "set_bar")
	max_Health = stats.max_health
	max_value = max_Health
	value = max_Health
