extends Spatial
class_name Voxel

export (Resource) var forgingMat

onready var outlineMesh = $OutlineMesh

var subvoxelMatrix = [] # 3D matrix of subvoxels
var heat: int = 0 # the voxel's current heat value

# Called when the node enters the scene tree for the first time.
func _ready():
	subvoxelMatrix.resize(5)				# x-dimension
	for x in 5:
		subvoxelMatrix[x] = []
		subvoxelMatrix[x].resize(5)			# y-dimension
		for y in 5:
			subvoxelMatrix[x][y] = []
			subvoxelMatrix[x][y].resize(5)	# z-dimension
			for z in 5:
				subvoxelMatrix[x][y][z] = find_node("Layer" + x).find_node("Row" + y).find_node("Subvoxel" + z)
				subvoxelMatrix[x][y][z].parent = self
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
	if !WorkshopAnvil.subvoxelMode && WorkshopAnvil.isActive:
		WorkshopAnvil.selectedVoxel = self
		outlineMesh.visible = true
	pass
func _on_VoxelHitbox_mouse_exited():
	if !WorkshopAnvil.subvoxelMode:
		WorkshopAnvil.selectedVoxel = null
		outlineMesh.visible = false
	pass
