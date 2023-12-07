extends Node2D

func _ready():
	Singleton.viewport_container = $ViewportContainer
	Singleton.viewport = $ViewportContainer/Viewport
