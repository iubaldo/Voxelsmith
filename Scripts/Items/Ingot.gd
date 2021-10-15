extends Item
class_name Ingot
# an item that can be used to begin smithing or add voxels to an existing smithingGrid
# note: maybe have a different color gradient for heating up ingots

onready var mat: SpatialMaterial = $IngotMesh.get_surface_material(0)

func _ready():
	add_to_group("Items")
	add_to_group("Heatable")
	collider = $CollisionShape
	return


func _physics_process(delta):
	mat.albedo_color = itemData.forgingMat.getMaterialColor()
	itemData.forgingMat.dissipateHeat(delta)
	return


func createItemData(newForgingMat: ForgingMaterial) -> void:
	var newIngotData: IngotData = Globals.ingotDataTemplate.new()
	newIngotData.forgingMat = newForgingMat
	setItemData(newIngotData)
	return
