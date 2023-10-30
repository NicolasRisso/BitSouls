extends Area2D

export(Resource) var item = null

func destroy():
	get_parent().queue_free()
