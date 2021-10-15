extends WorkstationData
class_name AnvilData


# anvil stats, determines what materials can be used on the anvil
var maxHardness: int
var maxHeat: int


func isValidMaterial(mat: ForgingMaterial) -> bool:
	if mat.hardness <= maxHardness && mat.heat <= maxHeat:
		return true
	return false


func rankUp() -> void:
	upgradeLevel += 1
	# increase stats
	return
