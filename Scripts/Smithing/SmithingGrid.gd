extends Node
# contains the voxels that make up a piece of worked metal
# note: can be carried as an item (ex. for reheating in the forge)

export onready var forgingMat: ForgingMaterial # what kind of material the grid is using

var gridMatrix = []
var gridBounds = Rect2(0, 0, 28, 14)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass 
	
func addIngot() -> void:
	pass

func addVoxel() -> void:
	pass
	
func removeVoxel(x: int, y: int) -> void:
	pass
