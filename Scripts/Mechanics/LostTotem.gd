extends StaticBody2D

export(bool) var useCustomRespawnPosition = false
export(Vector2) var offset = Vector2.ZERO

var respawnPosition = Vector2.ZERO

var isOn = false

onready var lostTotemInteract = $LostTotemInteract
onready var animatedSprite = $AnimatedSprite

func _ready():
	if !useCustomRespawnPosition: respawnPosition = position + Vector2(0, 10)
	else: respawnPosition = position - offset
	lostTotemInteract.respawnPosition = respawnPosition
	animatedSprite.animation = "Off"


func _on_LostTotemInteract_area_entered(area):
	if isOn: return
	animatedSprite.animation = "On"
	Signals.emit_signal("lostTotemFound")
	isOn = true
