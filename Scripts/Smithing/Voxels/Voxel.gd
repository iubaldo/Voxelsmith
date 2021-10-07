extends Spatial
class_name Voxel

export (Resource) var forgingMat

onready var outlineMesh = $OutlineMesh
onready var collider = $VoxelHitbox/CollisionShape

export var subvoxelMaterial: SpatialMaterial # voxel doesn't need its own material, so we pass this down to the subvoxels instead
var subvoxelMatrix = [] # 3D matrix of subvoxels
var heat: int = 0 # the voxel's current heat value
var gridPosition: Vector3 # the voxel's position in the gridMatrix
var normalizedGridPosition: Vector3 # the voxel's normalized position, without offset

var dishUp: bool = false # whether the voxel has been dished at Vector3.UP
var dishDown: bool = false # whether the voxel has been dished at Vector3.DOWN

func _ready():
	add_to_group("Voxels")
	subvoxelMatrix.resize(5)				# x-dimension
	for x in 5:
		subvoxelMatrix[x] = []
		subvoxelMatrix[x].resize(5)			# y-dimension
		for y in 5:
			subvoxelMatrix[x][y] = []
			subvoxelMatrix[x][y].resize(5)	# z-dimension
			for z in 5:
				subvoxelMatrix[x][y][z] = find_node("Layer" + var2str(y))\
				.find_node("Row" + var2str(x)).find_node("Subvoxel" + var2str(z))
				subvoxelMatrix[x][y][z].parent = self
				subvoxelMatrix[x][y][z].gridPosition = Vector3(x, y, z)
	pass


# removes the "bottom" 3x5 subvoxels from the top layer
func draw(forward: Vector3, up: Vector3) -> void: 
	var y: int = 4 if up == Vector3.UP else 0 # topmost layer
	var xRange
	var zRange
	
	if forward == Vector3.FORWARD:
		zRange = 5
		xRange = range(3, 5)
	elif forward == Vector3.BACK:
		zRange = 5
		xRange = range(0, 2)
	elif forward == Vector3.LEFT:
		zRange = range(3, 5)
		xRange = 5
	elif forward == Vector3.RIGHT:
		zRange = range(0, 2)
		xRange = 5
	
	for x in xRange:
		for z in zRange:
			if subvoxelMatrix[x][y][z] != null:
				subvoxelMatrix[x][y][z].queue_free()
				subvoxelMatrix[x][y][z] = null
	pass


# removes the top layer of subvoxels as well as the middle 3x3 subvoxels of the layer beneath
# if a neighboring voxel has been dished, connect the two
func dish(up: Vector3) -> void:
	var y1: int # topmost layer
	var y2: int # 2nd topmost layer
	if up == Vector3.UP:
		y1 = 4
		y2 = 3
		dishUp = true
	elif up == Vector3.DOWN:
		y1 = 0
		y2 = 1
		dishDown = true
	
	# 5x5 topmost layer
	for x in 5:
		for z in 5:
			if subvoxelMatrix[x][y1][z] != null:
				subvoxelMatrix[x][y1][z].queue_free()
				subvoxelMatrix[x][y1][z] = null
	 
	# middle 3x3 2nd topmost layer
	for x in range(1, 4):
		for z in range(1, 4):
			if subvoxelMatrix[x][y2][z] != null:
				subvoxelMatrix[x][y2][z].queue_free()
				subvoxelMatrix[x][y2][z] = null
	pass


# when a neighboring voxel has been dished, remove the voxels on the 2nd topmost layer that separate them
func connectDish(dir: Vector3, up: Vector3) -> void:
	var y: int = 3 if up == Vector3.UP else 1 # topmost layer
	var xRange
	var zRange 
	
	if dir == Vector3.FORWARD:
		zRange = range(1, 4)
		xRange = range(4, 5)
	elif dir == Vector3.BACK:
		zRange = range(1, 4)
		xRange = range(0, 1)
	elif dir == Vector3.LEFT:
		zRange = range(4, 5)
		xRange = range(1, 4)
	elif dir == Vector3.RIGHT:
		zRange = range(0, 1)
		xRange = range(1, 4)
	else:
		print("connectDish() - invalid dir!")
		return
	
	for x in xRange:
		for z in zRange:
			if subvoxelMatrix[x][y][z] != null:
				subvoxelMatrix[x][y][z].queue_free()
				subvoxelMatrix[x][y][z] = null
	
	pass


# note: subvoxels can only be removed, not added
func removeSubvoxel(var x: int, var y: int, var z: int) -> void:
	subvoxelMatrix[x][y][z].queue_free()
	subvoxelMatrix[x][y][z] = null
	pass


func compareVoxel(other: Voxel) -> bool:
	for x in 5:
		for y in 5:
			for z in 5:
				if (subvoxelMatrix[x][y][z] == null && other.subvoxelMatrix[x][y][z] != null) \
					|| (subvoxelMatrix[x][y][z] != null && other.subvoxelMatrix[x][y][z] == null):
					return false
	return true


func toggleVoxelCollider() -> void:
	collider.disabled = !collider.disabled
	pass


# note: these should only call if subvoxelMode = false and anvil is active
func _on_VoxelHitbox_mouse_entered():
	if !Globals.subvoxelMode && Globals.anvilActive:
		Globals.selectedVoxel = self
		outlineMesh.visible = true
	pass
func _on_VoxelHitbox_mouse_exited():
	if !Globals.subvoxelMode && Globals.anvilActive:
		Globals.selectedVoxel = null
		outlineMesh.visible = false
	pass
