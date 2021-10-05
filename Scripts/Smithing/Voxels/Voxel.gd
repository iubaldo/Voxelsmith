extends Spatial
class_name Voxel

export (Resource) var forgingMat

onready var outlineMesh = $OutlineMesh

var subvoxelMatrix = [] # 3D matrix of subvoxels
var heat: int = 0 # the voxel's current heat value
var gridPosition: Vector2

func _ready():
	subvoxelMatrix.resize(5)				# x-dimension
	for x in 5:
		subvoxelMatrix[x] = []
		subvoxelMatrix[x].resize(5)			# y-dimension
		for y in 5:
			subvoxelMatrix[x][y] = []
			subvoxelMatrix[x][y].resize(5)	# z-dimension
			for z in 5:
				subvoxelMatrix[x][y][z] = find_node("Layer" + var2str(x))\
				.find_node("Row" + var2str(y)).find_node("Subvoxel" + var2str(z))
				subvoxelMatrix[x][y][z].parent = self
				subvoxelMatrix[x][y][z].translation = Vector3(x, y, z)
	pass


func _process(delta):
	pass


# note: subvoxels can only be removed, not added
func removeSubvoxel(var x: int, var y: int, var z: int) -> void:
	subvoxelMatrix[x][y][z].queue_free()
	subvoxelMatrix[x][y][z] = null
	pass


func compareVoxel(var other: Voxel) -> bool:
	for x in 5:
		for y in 5:
			for z in 5:
				if (subvoxelMatrix[x][y][z] == null && other.subvoxelMatrix[x][y][z] != null) \
					|| (subvoxelMatrix[x][y][z] != null && other.subvoxelMatrix[x][y][z] == null):
					return false
	return true

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
