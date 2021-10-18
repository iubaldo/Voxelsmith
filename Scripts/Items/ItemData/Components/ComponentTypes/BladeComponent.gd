extends ComponentType
class_name BladeComponent

enum bladeSubtypes { ohSword, thSword, dagger }
var bladeSubtype


func initGridSize() -> void:
	match bladeSubtype:
		bladeSubtypes.ohSword:
			gridSize = Vector3(9, 1, 5)
		bladeSubtypes.thSword:
			gridSize = Vector3(13, 3, 7)
		bladeSubtypes.dagger:
			gridSize = Vector3(7, 1, 3)
		_:
			print("bladeSubtype is null or mismatch!")
	return
