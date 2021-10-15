extends Item
class_name Component
# a finished component after it has gone through the smithing process
# a componentItem may be subject to further heat treatment or other processes before assembly, but is not required

onready var mat: SpatialMaterial

func _ready():
	collider = $CollisionShape
	add_to_group("Items")
	add_to_group("Components")
	add_to_group("Heatable")
	return


func createItemData(newComponentType: ComponentType, newForgingMat: ForgingMaterial) -> void:
	var newComponentData: ComponentData = Globals.componentDataTemplate.new()
	newComponentData.forgingMat = newForgingMat
	setItemData(newComponentData)
	itemData.initComponentData()
	return


func _physics_process(delta):
	# itemData.forgingMat.getMaterialColor() -> implement when components are in the game
	itemData.forgingMat.dissipateHeat()
