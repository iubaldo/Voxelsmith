extends Resource
class_name ForgingMaterial
# describes the actual material used by the smithingGrid/ingot
# MaterialType provides a template, while a ForgingMaterial is a mutable version

export onready var renderMaterial: SpatialMaterial # determines the material used to render
export onready var mat: MaterialType # determines what type of material is being used
var matName: String
var matColor: Color # the material's color, depends on current heat level and tempering state

# these attributes can change during smithing
var heat: int = 0 # the material's current heat
var timesReheated: int = 0 # how many times the material has been reheated in a forge during smithing (heat treatment does not apply)
var maxReheats: int = 5 # how many times the material may be reheated until quality starts dropping
var quality: int = 100 # the overall quality of smithing
var hardness: int # range (1, 100), determines max sharpness
var weight: int # range (1, 100), determines final product's weight by (final weight = # of subvoxels * 0.04 * weight * density)
var toughness: int # range (1, 100), determines final product's durability


func initForgingMaterial(newMat: MaterialType) -> void:
	mat = newMat
	matName = newMat.matName
	hardness = mat.hardness
	toughness = mat.toughness
	return

func canSmith() -> bool:
	return heat >= mat.forgingTemp


func alloy(mat1: MaterialType, mat2: MaterialType, mat3: MaterialType = null) -> void:
	if mat3 == null:
		# two material alloy
		matName = (mat1.matName + "-" + mat2.matName + " Alloy")
		pass
	else:
		# three material alloy
		matName = (mat1.matName + "-" + mat2.matName + "-" + mat3.matName + " Alloy")
		
		pass
	return
