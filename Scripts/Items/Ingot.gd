extends Item
class_name Ingot
# an item that can be used to begin smithing or add voxels to an existing smithingGrid
# note: maybe have a different color gradient for heating up ingots

var mat: SpatialMaterial

func _ready():
	add_to_group("Items")
	collider = $CollisionShape
	mat = $IngotMesh.get_surface_material(0)
	return


func createItemData(newForgingMat: ForgingMaterial) -> void:
	var newIngotData: IngotData = Globals.ingotDataTemplate.new()
	newIngotData.forgingMat = newForgingMat
	setItemData(newIngotData)
	return
