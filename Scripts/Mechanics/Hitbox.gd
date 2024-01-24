extends Area2D

export(float) var damage = 10
export(float) var armorPierce = 0
export(float) var fireDamage = 0
export(float) var firePierce = 0
export(float) var knockbackForce = 0
export(float) var knockbackSpeed = 0
export(bool) var triggerInvincibility = true

func set_triggerInvincibility(value : bool):
	triggerInvincibility = value
