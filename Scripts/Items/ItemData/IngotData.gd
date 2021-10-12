extends ItemData
class_name IngotData

export onready var forgingMat: ForgingMaterial

func _init():
	itemType = itemTypes.ingot
	return

func initItemData(newForgingMat: ForgingMaterial) -> void:
	forgingMat = newForgingMat
	return
