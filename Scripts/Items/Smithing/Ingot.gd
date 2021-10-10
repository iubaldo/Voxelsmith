extends Item
class_name Ingot
# an item that can be used to begin smithing or add voxels to an existing smithingGrid
# note: maybe have a different color gradient for heating up ingots

export onready var ingotData: IngotData
var mat: SpatialMaterial

func _ready():
	add_to_group("Items")
	collider = $CollisionShape
	mat = $IngotMesh.get_surface_material(0)
	return


func setIngotData(newIngotData: IngotData) -> void:
	ingotData = newIngotData
	setItemData(ingotData)
	return
