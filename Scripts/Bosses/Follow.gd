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
	forceChangeStateTimer.stop()
	forceChangeStateTimer.wait_time = maxFollowTime
	forceChangeStateTimer.start()
	call_deferred("force_physics_process", true)
	animation_player.play("Idle")
	canForceField = true
	#debug.text = str(actualForceFieldChance)
	
func exit():
	set_physics_process(false)
	owner.set_physics_process(false)
	forceChangeStateTimer.stop()
	
func transition():
	var distance = owner.direction.length()
	var parent = get_parent()
	
	#parent.change_state("LaserShow")
	print(parent.get_parent().armorBuffed)
	if parent.get_parent().armorBuffed:
		parent.get_parent().armorBuffEffect()
		parent.change_state("ArmorBuff")
		return
	if parent.get_parent().overloadIncoming:
		parent.change_state("Overloaded")
		return
	if distance < distanceToAttack:
		parent.change_state("MeleeAttack")
	if distance >= distanceToAttack and distance <= distanceToForceField and canForceField:
		if randf() <= actualForceFieldChance:
			actualForceFieldChance = forceFieldChance
			parent.change_state("ForceField")
		else:
			timer.wait_time = 0.5
			canForceField = false
			timer.start()
	if distance > distanceToShoot:
		var chance = randi() % 2
		match chance:
			0:
				parent.change_state("HomingMissile")
			1:
				parent.change_state("LaserBeam")

func _on_Timer_timeout():
	canForceField = true
	actualForceFieldChance += forceFieldChanceIncresePerTry
	#debug.text = str(actualForceFieldChance)

func _on_ForceChangeState_timeout():
	get_parent().change_state("ForceField")

func force_physics_process(value : bool):
	set_physics_process(value)
	owner.set_physics_process(value)
