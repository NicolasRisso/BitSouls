extends State

export var bullet_node: PackedScene
var can_transition: bool = false

func enter():
	set_physics_process(true)
	animation_player.play("RangedAttack")

func shoot():
	var bullet = bullet_node.instance()
	bullet.position = owner.position
	get_tree().current_scene.get_node("YSort/Projectiles").add_child(bullet)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
		
func animation_ended():
	shoot()
	can_transition = true
