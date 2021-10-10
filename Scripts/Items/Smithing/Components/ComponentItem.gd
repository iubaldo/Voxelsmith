extends ItemData
class_name ComponentItem
# a finished component after it has gone through the smithing process
# a componentItem may be subject to further heat treatment or other processes before assembly, but is not required

export onready var component: ComponentType
export onready var forgingMat: ForgingMaterial

func _init():
	itemType = itemTypes.component
	return
