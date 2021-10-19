extends ComponentType
class_name HeadComponent

enum componentSubtypes { axe, mace, hammer }


func initGridSize() -> void:
	match componentSubtype:
		componentSubtypes.axe:
			gridSize = Vector3(9, 3, 7)
		componentSubtypes.mace:
			gridSize = Vector3(7, 7, 7)
		componentSubtypes.hammer:
			gridSize = Vector3(5, 7, 13)
		_:
			print("componentSubtype is null or mismatch!")
	return
