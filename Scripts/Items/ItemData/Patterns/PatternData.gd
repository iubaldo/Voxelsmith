extends ItemData
class_name PatternData
# contains the pattern of voxels to be filled in by an accompanying smithingGrid
# grid shape is standardized by componentType

export onready var componentType: ComponentType # what kind of component the pattern is using

var patternMatrix = []
var gridWidth: int
var gridHeight: int

func _init():
	itemType = itemTypes.pattern
	return


func initPatternData() -> void:
	# set grid bounds based on component's componentType
	return
