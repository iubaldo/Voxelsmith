extends Item
class_name Pattern
# the physical item holding a pattern

export onready var patternData: PatternData

func _ready():
	add_to_group("Items")
	return


func setPatternData(newPatternData: PatternData) -> void:
	patternData = newPatternData
	setItemData(patternData)
	return
