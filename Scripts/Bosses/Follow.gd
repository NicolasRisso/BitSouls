extends State

export(float) var distanceToAttack = 27.5
export(float) var distanceToForceField = 50
export(float) var distanceToShoot = 130

func enter():
	set_physics_process(true)
	owner.set_physics_process(true)
	animation_player.play("Idle")
	
func exit():
	set_physics_process(false)
	owner.set_physics_process(false)
	
func transition():
	var distance = owner.direction.length()
	
	if distance < distanceToAttack:
		get_parent().change_state("MeleeAttack")
	if distance >= distanceToAttack and distance <= distanceToForceField:
		get_parent().change_state("ForceField")
	if distance > distanceToShoot:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("HomingMissile")
			1:
				get_parent().change_state("LaserBeam")
