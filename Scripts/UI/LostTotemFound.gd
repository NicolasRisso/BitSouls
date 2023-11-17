extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	Signals.connect("lostTotemFound", self, "playAnim")
	
func playAnim():
	animationPlayer.play("Show")
