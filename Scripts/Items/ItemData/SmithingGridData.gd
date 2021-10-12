extends ItemData
class_name SGData

export onready var forgingMat: ForgingMaterial # what kind of material the grid is using, defined by the ingot used
export onready var component: ComponentData # what kind of component the grid is using, defined by the pattern used
export onready var patternData: PatternData # the pattern the grid is using
var completed: bool = false # whether or not the grid's pattern has been completed
var voxelPool: int = 0 # how many voxels are available to be added

# later add support for setting max bounds when free smithing
# note: (0, 0) = (width / 2, height / 2)
var gridMatrix = []
var gridWidth: int = 29
var gridHeight: int = 15
var gridCenter: Vector2 = Vector2(gridWidth / 2, gridHeight / 2)
var gridBounds: Rect2 = Rect2(0, 0, gridWidth, gridHeight) # grid coords

func _init():
	itemType = itemTypes.smithingGrid
	return
