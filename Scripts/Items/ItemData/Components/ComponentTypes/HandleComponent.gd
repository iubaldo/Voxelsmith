extends ComponentType
class_name HandleComponent

enum componentSubtypes { oh, hnh, th, medium, long }


func initGridSize() -> void:
	match componentSubtype:
		componentSubtypes.oh:
			gridSize = Vector3(3, 4, 3)
		componentSubtypes.hnh:
			gridSize = Vector3(3, 5, 3)
		componentSubtypes.th:
			gridSize = Vector3(3, 7, 3)
		componentSubtypes.medium:
			gridSize = Vector3(3, 11, 3)
		componentSubtypes.long:
			gridSize = Vector3(3, 15, 3)
		_:
			print("componentSubtype is null or mismatch!")
	return
