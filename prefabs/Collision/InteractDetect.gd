extends Area2D

func _on_InteractDetect_area_entered(area):
	Signals.emit_signal("interactArea", true)

func _on_InteractDetect_area_exited(area):
	Signals.emit_signal("interactArea", false)
