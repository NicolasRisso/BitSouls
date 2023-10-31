extends Area2D

export(Resource) var item = null

const pickUpSound = preload("res://prefabs/Audios/AudioPlayer.tscn")

func destroy():
	var pickUpSoundEffect = pickUpSound.instance()
	get_tree().get_root().add_child(pickUpSoundEffect)
	get_parent().queue_free()
