extends StaticBody2D

export(bool) var useCustomRespawnPosition = false
export(Vector2) var offset = Vector2.ZERO

var respawnPosition = Vector2.ZERO

var isOn = false

var isOnCooldown = false

onready var lostTotemInteract = $LostTotemInteract
onready var animatedSprite = $AnimatedSprite
onready var audioStream = $AudioStreamPlayer
onready var timer = $Timer

func _ready():
	if !useCustomRespawnPosition: respawnPosition = position + Vector2(0, 10)
	else: respawnPosition = position - offset
	lostTotemInteract.respawnPosition = respawnPosition
	animatedSprite.animation = "Off"


func _on_LostTotemInteract_area_entered(_area):
	if !isOn:
		animatedSprite.animation = "On"
		Signals.emit_signal("lostTotemFound")
		isOn = true
	else:
		if isOnCooldown: return
		Signals.emit_signal("lostTotemInteracted")
		audioStream.play()
		isOnCooldown = true
		timer.wait_time = 4
		timer.start()

func _on_Timer_timeout():
	isOnCooldown = false
