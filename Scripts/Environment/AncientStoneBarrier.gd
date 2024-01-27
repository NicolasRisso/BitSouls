extends StaticBody2D

onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	Signals.connect("startBossFight", self, "BlockArena")
	PlayerStats.connect("died", self, "sleep")
	animationPlayer.play("Hiden")

func BlockArena():
	animationPlayer.play("Surge")
	
func surge_anim_ended():
	animationPlayer.play("Idle")
	
func sleep():
	animationPlayer.play("Hiden")
