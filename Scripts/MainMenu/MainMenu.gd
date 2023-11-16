extends Control

func _ready():
	$Node2D/VBoxContainer/NewGame.grab_focus()


func _on_NewGame_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_Continue_pressed():
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_ExitGame_pressed():
	get_tree().quit()
