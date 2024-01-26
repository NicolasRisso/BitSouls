extends State

onready var timer = $Timer
onready var forceChangeStateTimer = $ForceChangeState

export(float) var distanceToAttack = 27.5
export(float) var distanceToForceField = 50
export(float) var distanceToShoot = 130

export(float) var forceFieldChance = 0.2
export(float) var forceFieldChanceIncresePerTry = 0.1

export(float) var maxFollowTime = 7.5

var actualForceFieldChance = forceFieldChance

var canForceField : bool = true

func enter():
	forceChangeStateTimer.wait_time = maxFollowTime
	forceChangeStateTimer.start()
	set_physics_process(true)
	owner.set_physics_process(true)
	animation_player.play("Idle")
	canForceField = true
	#debug.text = str(actualForceFieldChance)
	
func exit():
	set_physics_process(false)
	owner.set_physics_process(false)
	forceChangeStateTimer.stop()
	
func transition():
	var distance = owner.direction.length()
	
	if distance < distanceToAttack:
		get_parent().change_state("MeleeAttack")
	if distance >= distanceToAttack and distance <= distanceToForceField and canForceField:
		if randf() <= actualForceFieldChance:
			actualForceFieldChance = forceFieldChance
			get_parent().change_state("ForceField")
		else:
			timer.wait_time = 0.5
			canForceField = false
			timer.start()
	if distance > distanceToShoot:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("HomingMissile")
			1:
				get_parent().change_state("LaserBeam")

func _on_Timer_timeout():
	canForceField = true
	actualForceFieldChance += forceFieldChanceIncresePerTry
	#debug.text = str(actualForceFieldChance)

func _on_ForceChangeState_timeout():
	get_parent().change_state("ForceField")
