extends Item
class_name Pattern
# the physical item holding a pattern

func _ready():
	add_to_group("Items")
	return


func createItemData(newComponentType: ComponentType) -> void:
	var newPatternData: PatternData = Globals.patternDataTemplate.new()
	newPatternData.componentType = newComponentType
	setItemData(newPatternData)
	itemData.initPatternData()
	return
