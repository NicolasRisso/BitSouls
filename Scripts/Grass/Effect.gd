extends AnimatedSprite

export(bool) var explosive = false
export(float) var explosionDamage = 0.0
export(float) var explosionPierce = 0.0
export(float) var knockbackForce = 0.0
export(float) var knockbackSpeed = 0.0

export(float) var frameToExplode = 7

var hitbox
var collisionShape

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")
	if explosive:
		hitbox = $Hitbox
		collisionShape = $Hitbox/CollisionShape2D
		hitbox.fireDamage = explosionDamage
		hitbox.firePierce = explosionPierce
		hitbox.knockbackForce = knockbackForce
		hitbox.knockbackSpeed = knockbackSpeed

func _on_animation_finished():
	call_deferred("_destroy_self")

func _destroy_self():
	queue_free()

func _on_EnemyDeathEffect_frame_changed():
	if !explosive: 
		collisionShape.disable = true
		return
	if frame == frameToExplode:
		collisionShape.disabled = false
	if frame == frameToExplode + 1:
		collisionShape.disabled = true
