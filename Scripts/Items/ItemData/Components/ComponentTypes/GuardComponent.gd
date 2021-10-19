extends ComponentType
class_name GuardComponent

enum componentSubtypes { ohGuard, thGuard, daggerGuard }


func initGridSize() -> void:
	match componentSubtype:
		componentSubtypes.ohGuard:
			gridSize = Vector3(3, 3, 7)
		componentSubtypes.thGuard:
			gridSize = Vector3(3, 3, 11)
		componentSubtypes.daggerGuard:
			gridSize = Vector3(3, 3, 5)
		_:
			print("componentSubtype is null or mismatch!")
	return
