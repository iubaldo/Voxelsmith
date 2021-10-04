extends Resource
class_name ForgingMaterial
# the actual material script used by the voxel

export onready var material: MaterialType # determines what type of material is being used
var matName: String

# these attributes can change during smithing
var heat: int = 0 # the material's current heat level
var hardness: int # range (1, 100), determines max sharpness
var density: int # range (1, 100), determines hammer strength required to shape
var weight: int # range (1, 100), determines final product's weight by (final weight = # of subvoxels * 0.04 * weight * density)
var toughness: int # range (1, 100), determines final product's durability

func _ready():
	if material != null:
		matName = MaterialType.materialTypes.keys()[material.matType]
		hardness = material.hardness
		density = material.density
		toughness = material.toughness
	pass

func alloy(mat1: MaterialType, mat2: MaterialType, mat3: MaterialType = null) -> void:
	if mat3 == null:
		# two material alloy
		matName = MaterialType.materialTypes.keys()[mat1.matType] + MaterialType.materialTypes.keys()[mat2.matType]
		pass
	else:
		# three material alloy
		pass
	pass
