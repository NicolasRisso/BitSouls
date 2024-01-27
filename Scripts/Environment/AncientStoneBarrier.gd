extends StaticBody2D

onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	Signals.connect("startBossFight", self, "BlockArena")
	animationPlayer.play("Hiden")

func BlockArena():
	animationPlayer.play("Surge")
	
func surge_anim_ended():
	animationPlayer.play("Idle")
