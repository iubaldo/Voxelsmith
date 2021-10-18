extends ComponentType
class_name HeadComponent

enum headSubtypes { axe, mace, hammer }
var headSubtype


func initGridSize() -> void:
	match headSubtype:
		headSubtypes.axe:
			gridSize = Vector3(9, 3, 7)
		headSubtypes.mace:
			gridSize = Vector3(7, 7, 7)
		headSubtypes.hammer:
			gridSize = Vector3(5, 7, 13)
		_:
			print("headSubtype is null or mismatch!")
	return
