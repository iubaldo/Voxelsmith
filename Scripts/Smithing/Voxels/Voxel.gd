extends Spatial
class_name Voxel

export (Resource) var forgingMat

var subvoxelMatrix = []

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
				pass
			pass
		pass
	pass


func _process(delta):
	
	pass
