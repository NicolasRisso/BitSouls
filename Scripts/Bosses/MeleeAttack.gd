extends State

export(float) var distanceToFollowBack = 28.5

var attackedAtLeastOnce: bool = false

func enter():
	set_physics_process(true)
	attackedAtLeastOnce = false
	animation_player.play("MeleeAttack")

func transition():
	if owner.direction.length() > distanceToFollowBack and attackedAtLeastOnce:
		get_parent().change_state("Follow")

func animation_ended():
	attackedAtLeastOnce = true
