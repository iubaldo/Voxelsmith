extends Item
class_name Component
# a finished component after it has gone through the smithing process
# a componentItem may be subject to further heat treatment or other processes before assembly, but is not required

func _ready():
	collider = $CollisionShape
	add_to_group("Items")
	add_to_group("Components")
	return


func createItemData(newComponentType: ComponentType, newForgingMat: ForgingMaterial) -> void:
	var newComponentData: ComponentData = Globals.componentDataTemplate.new()
	newComponentData.forgingMat = newForgingMat
	setItemData(newComponentData)
	itemData.initComponentData()
	return
