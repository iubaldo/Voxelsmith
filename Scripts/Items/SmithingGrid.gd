extends Item
class_name SmithingGrid
# contains the physical voxels that make up a piece of worked metal
# note: might have to replace Rect2 variables with AABB counterparts for smithing in 3d

onready var meltTimer: Timer = $MeltTimer
onready var centerVoxelOutline = $CenterVoxelOutline
onready var collisionShape: CollisionShape = $CollisionShape

var melt: bool = false

# constants inherited from sgData
var gridWidth: int
var gridHeight: int
var gridCenter: Vector2
var gridBounds: Rect2

const STEP_SIZE: float = 0.1 # constant for converting voxel's worldspace coords to normalized coords

func _ready():
	collider = $CollisionShape
	add_to_group("Items")
	add_to_group("Heatable")
	return


func createItemData(newForgingMat: ForgingMaterial, newPatternData: PatternData) -> void:
	var newSGData: SGData = Globals.sgDataTemplate.new()
	newSGData.forgingMat = newForgingMat
	newSGData.patternData = newPatternData
	newSGData.componentType = newSGData.patternData.componentType
	setItemData(newSGData)
	initSmithingGrid()
	return


func initSmithingGrid() -> void:
	gridWidth = itemData.gridWidth
	gridHeight = itemData.gridHeight
	gridCenter = itemData.gridCenter
	gridBounds = itemData.gridBounds
	
	initGrid(itemData.forgingMat)
	createIngot()
	pass


func _physics_process(delta):
	if !Globals.isAnvilActive() || (is_instance_valid(Globals.selectedVoxel) \
		&& Globals.selectedVoxel.gridPosition == Vector3(gridCenter.x, 0, gridCenter.y)):
		centerVoxelOutline.visible = false
	else:
		centerVoxelOutline.visible = true
	
	itemData.setSubvoxelColor(itemData.forgingMat.getMaterialColor())
	itemData.forgingMat.dissipateHeat(delta)
	
	if itemData.forgingMat.heat > itemData.forgingMat.matType.smeltingTemp && meltTimer.time_left == 0:
		print("start melt countdown")
		meltTimer.start()

	# if we fall back below smelting temp, abort
	if meltTimer.time_left > 0 && itemData.forgingMat.heat <= itemData.forgingMat.matType.smeltingTemp:
		print("abort melt countdown")
		meltTimer.stop()
	return


func _input(event):
	if event.is_action_pressed("debug_PrintGridMatrix"):
		debugPrintGridMatrix()
	return


func debugPrintGridMatrix() -> void:
	for y in gridHeight:
		var result = ""
		for x in gridWidth:
			if itemData.gridMatrix[x][y] != null:
				result = result + "*"
			else:
				result = result + "-"
		print(result)
		
	return


# initializes the gridMatrix and fills it with null values
func initGrid(var mat: ForgingMaterial) -> void:
	if !itemData:
		print("initGrid() - itemData is null!")
		return
	
	itemData.forgingMat = mat
	
	for x in gridWidth:
		itemData.gridMatrix.append([])
		for y in gridHeight:
			itemData.gridMatrix[x].append(null)
	return 


# for adding a full ingot to a new grid, ingot size is 5x7
func createIngot() -> void: 
	for x in range(-2 + gridCenter.x, 3 + gridCenter.x):
		for z in range(-1 + gridCenter.y, 2 + gridCenter.y):
			createVoxel(Vector3(x, 0, z))
			
	return


# to-do later: add anvil bounds to globals and check if voxel is within smithing area
func createVoxel(targetPos: Vector3) -> void: # grid coords
	if isPositionValid(targetPos):
		var newVoxel = Globals.voxelTemplate.instance()
		add_child(newVoxel)
		newVoxel.translation = Vector3((targetPos.x - gridCenter.x) * STEP_SIZE, 0, (targetPos.z - gridCenter.y) * STEP_SIZE) # worldspace coords
		newVoxel.forgingMat = itemData.forgingMat
		newVoxel.gridPosition = targetPos
		newVoxel.normalizedGridPosition = Vector3(targetPos.x - gridCenter.x, 0, targetPos.z - gridCenter.y)
		itemData.gridMatrix[targetPos.x][targetPos.z] = newVoxel # grid coords
	else:
		print("createVoxel - targetPos " + var2str(Vector2(targetPos.x, targetPos.z)) + " out of bounds!")
	return


func destroyVoxel(targetPos: Vector3) -> void: # grid coords
	if isPositionValid(targetPos):
		itemData.gridMatrix[targetPos.x][targetPos.z].queue_free()
		itemData.gridMatrix[targetPos.x][targetPos.z] = null
	else:
		print("destroyVoxel - targetPos " + var2str(targetPos) + " out of bounds!")
	return


func getVoxel(targetPos: Vector3): # grid coords
	if isPositionValid(targetPos):
		return itemData.gridMatrix[targetPos.x][targetPos.z]
	
	print ("getVoxel() - targetPos  " + var2str(targetPos) + " out of bounds!")
	return null


func doesVoxelExist(targetPos: Vector3) -> bool: # grid coords
	if isPositionValid(targetPos):
		return itemData.gridMatrix[targetPos.x][targetPos.z] != null
	
	print ("doesVoxelExist() - targetPos  " + var2str(targetPos) + " out of bounds!")
	return false


func isPositionValid(targetPos: Vector3) -> bool: # grid coords
	return gridBounds.has_point(Vector2(targetPos.x, targetPos.z))


func getVoxelPosition(targetVoxel: Voxel): # returns Vector3
	if itemData.gridMatrix.find(targetVoxel):
		return targetVoxel.gridPosition
		
	print("getVoxelPosition() - targetVoxel is null!")
	return null


func canSmith() -> bool:
	return itemData.forgingMat.heat >= itemData.forgingMat.matType.forgingTemp


# used when creating new smithingGrids on the anvil
func setCollisionShape() -> void:
	if !itemData.component:
		print("setCollisionShape() - component is null!")
		return
	if !itemData.component.gridSize:
		print("setCollisionShape() - component gridSize is null!")
		return
	
	collisionShape.shape.extents = itemData.component.gridSize * STEP_SIZE
	if itemData.component.gridSize.y == 3:
		get_global_transform().origin += Vector3.UP * STEP_SIZE
	
	print(var2str(collisionShape.shape.extents))
	return


#func meltVoxel() -> void:
#	var searched = []
#	for vox in itemData.gridMatrix:
#		if vox:
#			var numNeighbors = 0
#			numNeighbors += 1 if doesVoxelExist(vox.gridPosition + Vector3.FORWARD) else 0
#			numNeighbors += 1 if doesVoxelExist(vox.gridPosition + Vector3.BACK) else 0
#			numNeighbors += 1 if doesVoxelExist(vox.gridPosition + Vector3.LEFT) else 0
#			numNeighbors += 1 if doesVoxelExist(vox.gridPosition + Vector3.RIGHT) else 0
#			var pair = [vox, numNeighbors]
#			searched.push_back(pair)
#	searched.sort_custom(neighborSort, "sortAscending")
#	destroyVoxel(searched[0].gridPosition)
#	return
#
#
#class neighborSort:
#	static func sortAscending(a, b):
#		if a[1] < b[1]:
#			return true
#		return false


# starts melting voxels one-by-one
func _on_MeltTimer_timeout():
	itemize()
	collider.disabled = true
	gravity_scale = 0.1
	melt = true
	emit_signal("melted", self)
	return


func _on_VisibilityNotifier_screen_exited():
	if melt:
		self.queue_free()
	return
