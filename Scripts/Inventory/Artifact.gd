extends Item
class_name Artifact

enum BuffType{
	DAMAGE,
}

export(int) var effect_index = -1
export(BuffType) var buffType = BuffType.DAMAGE

#0 (Knight's Ring): Deals 10% more damage.

func damageBuffs(index, damage):
	if index == 0:
		print(damage * 1.1)
		return damage * 1.1
	return damage
