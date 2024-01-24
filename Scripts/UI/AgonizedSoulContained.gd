extends Node2D

onready var animationPlayer = $AnimationPlayer

func boss_conection(boss):
	boss.connect("death", self, "playAnim")
	
func playAnim():
	animationPlayer.play("Show")
	print("a")
