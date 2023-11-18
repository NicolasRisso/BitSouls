extends StaticBody2D

export(int) var textureID = 0
export(bool) var flipH = false
export(String) var text = ""

onready var sprite = $Sprite
onready var interactionArea = $InteractionArea

const textures = [
	preload("res://Art/World/Message.png"),
	preload("res://Art/World/Message2.png"),
	preload("res://Art/World/Message3.png"),
	preload("res://Art/World/Message4.png")
]

func _ready():
	if flipH: sprite.flip_h = true
	if textureID < textures.size() and textureID >= 0:
		sprite.texture = textures[textureID]
	interactionArea.text = text
