extends StaticBody2D

onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	Signals.connect("startBossFight", self, "BlockArena")
	Signals.connect("bossDefeated", self, "UnblockArena")
	PlayerStats.connect("died", self, "sleep")
	animationPlayer.play("Hiden")

func BlockArena():
	animationPlayer.play("Surge")
	
func UnblockArena():
	animationPlayer.play("Hide")
	
func surge_anim_ended():
	animationPlayer.play("Idle")
	
func sleep():
	animationPlayer.play("Hiden")
