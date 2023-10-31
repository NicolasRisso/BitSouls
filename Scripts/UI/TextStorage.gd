extends Resource
class_name TextStorage

signal labelChanged

var name = "" setget nameChanged
var description = "" setget descriptionChanged

func nameChanged(value):
	name = value
	emit_signal("labelChanged")
	
func descriptionChanged(value):
	description = value
	emit_signal("labelChanged")
