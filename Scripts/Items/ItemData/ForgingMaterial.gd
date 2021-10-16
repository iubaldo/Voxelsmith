extends Resource
class_name ForgingMaterial
# describes the actual material used by the smithingGrid/ingot
# MaterialType provides a template, while a ForgingMaterial is a mutable version

export onready var renderMaterial: SpatialMaterial # determines the material used to render
export onready var matType: MaterialType # determines what type of material is being used
var matName: String
var matColor: Color # the material's color, depends on current heat level and tempering state

# these attributes can change during smithing
var heat: float = 0 # the material's current heat
const maxHeat: int = 10000 # the maximum possible heat
var timesReheated: int = 0 # how many times the material has been reheated in a forge during smithing (heat treatment does not apply)
var maxReheats: int = 5 # how many times the material may be reheated until quality starts dropping
var quality: int = 100 # the overall quality of smithing
var hardness: int # range (1, 100), determines max sharpness
var weight: int # range (1, 100), determines final product's weight by (final weight = # of subvoxels * 0.04 * weight * density)
var toughness: int # range (1, 100), determines final product's durability


func initForgingMaterial(newMat: MaterialType) -> void:
	matType = newMat
	matName = newMat.matName
	hardness = matType.hardness
	toughness = matType.toughness
	return


func getMaterialColor() -> Color:
	var scaledHeat = heat / matType.smeltingTemp
	if matType.canTemper:
		return matType.temperGradient.interpolate(scaledHeat)
	else:
		return matType.colorGradient.interpolate(scaledHeat)


func accumulateHeat(targetHeat: int, delta: float) -> void:
	if heat == 0: # prevents division by zero
		heat = 1
		return
	
	heat *= 1 + ((matType.heatResistance / 100.0) * (targetHeat / heat) * delta)
	if heat > maxHeat:
		heat = maxHeat
	return
func dissipateHeat(delta: float) -> void:
	if heat < 1:
		heat = 0
		return
		
	heat *= 1 - (((float(11 - matType.heatResistance) / 100) * (heat / maxHeat)) * delta)
	return


func canSmith() -> bool:
	return heat >= matType.forgingTemp


func alloy(mat1: MaterialType, mat2: MaterialType, mat3: MaterialType = null) -> void:
	
	if mat3 == null:
		# two material alloy
		matName = (mat1.matName + "-" + mat2.matName + " Alloy")
		# check for special alloys
		# else average attributes
		pass
	else:
		# three material alloy
		matName = (mat1.matName + "-" + mat2.matName + "-" + mat3.matName + " Alloy")
		# check for special alloys
		# else average attributes
		pass
	return
