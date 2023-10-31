extends AudioStreamPlayer

func _ready():
	connect("finished", self, "_on_audio_finished")

func _on_audio_finished():
	queue_free()
