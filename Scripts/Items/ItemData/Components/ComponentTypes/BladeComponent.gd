extends ComponentType
class_name BladeComponent

enum componentSubtypes { ohSword, thSword, dagger, spear }


func initGridSize() -> void:
	match componentSubtype:
		componentSubtypes.ohSword:
			gridSize = Vector3(9, 1, 5)
		componentSubtypes.thSword:
			gridSize = Vector3(13, 3, 7)
		componentSubtypes.dagger:
			gridSize = Vector3(7, 1, 3)
		componentSubtypes.spear:
			gridSize = Vector3(13, 7, 3)
		_:
			print("componentSubtype is null or mismatch!")
	return
