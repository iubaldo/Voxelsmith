extends ItemData
class_name ComponentData
# describes the kind of component this componentItem or smithingGrid is using

export onready var forgingMat: ForgingMaterial
export onready var componentType: ComponentType

func _init():
	itemType = itemTypes.component
	return
