extends ComponentType
class_name GuardComponent

enum guardSubtypes { ohSword, thSword, dagger, polearm }
var guardSubtype


func initGridSize() -> void:
	match guardSubtype:
		guardSubtypes.ohSword:
			gridSize = Vector3(3, 3, 7)
		guardSubtypes.thSword:
			gridSize = Vector3(3, 3, 11)
		guardSubtypes.dagger:
			gridSize = Vector3(3, 3, 5)
		_:
			print("guardSubtype is null or mismatch!")
	return
