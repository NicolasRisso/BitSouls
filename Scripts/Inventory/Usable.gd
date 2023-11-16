extends Item
class_name Usable

enum UsableType {
	HEAL,
	BUFF
}

export(UsableType) var usableType = UsableType.HEAL
export(bool) var isReusable = false
