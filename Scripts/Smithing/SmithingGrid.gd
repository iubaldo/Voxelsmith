extends Spatial
class_name SmithingGrid
# contains the physical voxels that make up a piece of worked metal
# note: should be able to be carried as an item (ex. for reheating in the forge)

export onready var forgingMat: ForgingMaterial # what kind of material the grid is using
onready var voxelTemplate = preload("res://Scenes/Smithing/Voxels/Voxel.tscn")

const STEP_SIZE: float = 0.1 # constant for converting to a normalized coordinate system for voxels

var completed: bool = false # whether or not the grid's pattern has been completed
var voxelPool: int = 0 # how many voxels are available to be added

var gridMatrix = []
var gridBounds = Rect2(-14, 7, 14, 7) # later add support for setting max bounds when free smithing


func initGrid(var mat: ForgingMaterial) -> void:
	forgingMat = mat
	gridMatrix.resize(5)				# x-dimension
	for x in 5:
		gridMatrix[x] = []
		gridMatrix[x].resize(5)			# y-dimension
	pass 


func createIngot() -> void: # for adding a full ingot to a new grid, ingot size is 5x7
	for x in range(-2, 2):
		for z in range(-1, 1):
			addVoxel(x, z)
	pass


func addVoxel(var x: int, var z: int) -> void:
	var newVoxel = voxelTemplate.instance()
	add_child(newVoxel)
	newVoxel.translation = Vector3(x * STEP_SIZE, 0, z * STEP_SIZE)
	print("added voxel at " + var2str(Vector3(x * STEP_SIZE, 0, z * STEP_SIZE)))
	newVoxel.forgingMat = forgingMat
	newVoxel.gridPosition = Vector2(x, z)
	gridMatrix[x][z] = newVoxel
	pass


func removeVoxel(var x: int, var z: int) -> void:
	gridMatrix[x][z].queue_free()
	pass
