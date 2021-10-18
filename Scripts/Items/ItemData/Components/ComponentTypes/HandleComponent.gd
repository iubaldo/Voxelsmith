extends ComponentType
class_name HandleComponent

enum handleSubtypes { oh, hnh, th, medium, long }
var handleSubtype


func initGridSize() -> void:
	match handleSubtype:
		handleSubtypes.oh:
			gridSize = Vector3(3, 4, 3)
		handleSubtypes.hnh:
			gridSize = Vector3(3, 5, 3)
		handleSubtypes.th:
			gridSize = Vector3(3, 7, 3)
		handleSubtypes.medium:
			gridSize = Vector3(3, 11, 3)
		handleSubtypes.long:
			gridSize = Vector3(3, 15, 3)
		_:
			print("handleSubtype is null or mismatch!")
	return
