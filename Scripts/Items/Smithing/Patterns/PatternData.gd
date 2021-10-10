extends ItemData
class_name PatternData
# contains the pattern of voxels to be filled in by an accompanying smithingGrid
# grid shape is standardized by componentType

export onready var component: ComponentType # what kind of component the pattern is using

var patternMatrix = []
var gridWidth: int
var gridHeight: int

func initPatternData(newComponent: ComponentType) -> void:
	component = newComponent
	
	# set grid bounds based on component
	return
