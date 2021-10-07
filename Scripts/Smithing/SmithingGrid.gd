extends Spatial
class_name SmithingGrid
# contains the physical voxels that make up a piece of worked metal
# note: should be able to be carried as an item (ex. for reheating in the forge)

export onready var forgingMat: ForgingMaterial # what kind of material the grid is using
onready var voxelTemplate = preload("res://Scenes/Smithing/Voxels/Voxel.tscn")
onready var centerVoxelOutline = $CenterVoxelOutline

const STEP_SIZE: float = 0.1 # constant for converting voxel's worldspace coords to normalized coords

var completed: bool = false # whether or not the grid's pattern has been completed
var voxelPool: int = 0 # how many voxels are available to be added


# later add support for setting max bounds when free smithing
# note: (0, 0) = (width / 2, height / 2)
var gridMatrix = []
var gridWidth: int = 29
var gridHeight: int = 15
var gridCenter: Vector2 = Vector2(gridWidth / 2, gridHeight / 2)
var gridBounds: Rect2 = Rect2(0, 0, gridWidth, gridHeight) # grid coords


func _physics_process(delta):
	if !Globals.anvilActive || (is_instance_valid(Globals.selectedVoxel) \
	&& Globals.selectedVoxel.gridPosition == Vector3(gridCenter.x, 0, gridCenter.y)):
		centerVoxelOutline.visible = false
	else:
		centerVoxelOutline.visible = true


func _input(event):
	if event.is_action_pressed("debug_PrintGridMatrix"):
		debugPrintGridMatrix()
	pass


func debugPrintGridMatrix() -> void:
	for y in gridHeight:
		var result = ""
		for x in gridWidth:
			if gridMatrix[x][y] != null:
				result = result + "*"
			else:
				result = result + "-"
		print(result)
		
	pass


# initializes the gridMatrix and fills it with null values
func initGrid(var mat: ForgingMaterial) -> void:
	forgingMat = mat
	
	for x in gridWidth:
		gridMatrix.append([])
		for y in gridHeight:
			gridMatrix[x].append(null)
	pass 


# for adding a full ingot to a new grid, ingot size is 5x7
func createIngot() -> void: 
	for x in range(-2 + gridCenter.x, 3 + gridCenter.x):
		for z in range(-1 + gridCenter.y, 2 + gridCenter.y):
			createVoxel(Vector3(x, 0, z))
			
	print("created ingot")
	pass


# to-do later: add anvil bounds to globals and check if voxel is within smithing area
func createVoxel(targetPos: Vector3) -> void: # grid coords
	if isPositionValid(targetPos):
		var newVoxel = voxelTemplate.instance()
		add_child(newVoxel)
		newVoxel.translation = Vector3((targetPos.x - gridCenter.x) * STEP_SIZE, 0, (targetPos.z - gridCenter.y) * STEP_SIZE) # worldspace coords
		newVoxel.forgingMat = forgingMat
		newVoxel.gridPosition = targetPos
		newVoxel.normalizedGridPosition = Vector3(targetPos.x - gridCenter.x, 0, targetPos.z - gridCenter.y)
		gridMatrix[targetPos.x][targetPos.z] = newVoxel # grid coords
	else:
		print("createVoxel - targetPos " + var2str(Vector2(targetPos.x, targetPos.z)) + " out of bounds!")
	pass


func destroyVoxel(targetPos: Vector3) -> void: # grid coords
	if isPositionValid(targetPos):
		gridMatrix[targetPos.x][targetPos.z].queue_free()
		gridMatrix[targetPos.x][targetPos.z] = null
	else:
		print("destroyVoxel - targetPos " + var2str(targetPos) + " out of bounds!")
	pass


func getVoxel(targetPos: Vector3): # grid coords
	if isPositionValid(targetPos):
		return gridMatrix[targetPos.x][targetPos.z]
	
	print ("getVoxel() - targetPos  " + var2str(targetPos) + " out of bounds!")
	return null


func doesVoxelExist(targetPos: Vector3) -> bool: # grid coords
	if isPositionValid(targetPos):
		return gridMatrix[targetPos.x][targetPos.z] != null
	
	print ("doesVoxelExist() - targetPos  " + var2str(targetPos) + " out of bounds!")
	return false


func isPositionValid(targetPos: Vector3) -> bool: # grid coords
	return gridBounds.has_point(Vector2(targetPos.x, targetPos.z))


func getVoxelPosition(targetVoxel: Voxel): # returns Vector3
	if gridMatrix.find(targetVoxel):
		return targetVoxel.gridPosition
		
	print("getVoxelPosition() - targetVoxel is null!")
	return null


