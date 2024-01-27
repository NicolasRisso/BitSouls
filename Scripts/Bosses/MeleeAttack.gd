extends State

export(float) var distanceToFollowBack = 28.5
export(float) var maxDistanceTollerance = 60
export(float) var chanceToTripleAttack = 0.3

export(float) var maxTimeToForcedForceField = 7

onready var timer = $Timer
onready var timer2 = $Timer2

var attackedAtLeastOnce: bool = false

func enter():
	set_physics_process(true)
	attackedAtLeastOnce = false
	timer.wait_time = maxTimeToForcedForceField
	timer.start()
	if randf() <= chanceToTripleAttack:
		animation_player.play("TripleAttack")
	else:
		animation_player.play("MeleeAttack")

func exit():
	set_physics_process(false)
	timer.stop()
	timer2.stop()

func transition():
	if (owner.direction.length() > distanceToFollowBack and attackedAtLeastOnce) or owner.direction.length() > maxDistanceTollerance:
		timer.stop()
		timer2.stop()
		get_parent().change_state("Follow")

func animation_ended():
	attackedAtLeastOnce = true

func _on_Timer_timeout():
	get_parent().change_state("ForceField")

func animation_started(anim_name):
	timer2.wait_time = animation_player.get_animation(anim_name).length
	timer2.start()

func _on_Timer2_timeout():
	attackedAtLeastOnce = true
