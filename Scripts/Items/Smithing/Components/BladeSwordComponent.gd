extends ComponentType
class_name BladeSwordComponent
# describes sword blade components

enum swordSubtypes { oneHanded, twoHanded }
enum swordCategories { singleEdged, doubleEdged, thrusting }
var swordSubtype # determines grid size
var swordCategory # determines what kind of sword blade the component is

func _init():
	pass


func setGridSize():
	if swordSubtype == swordSubtypes.oneHanded:
		gridSize = Vector3(15, 1, 7)
	elif swordSubtype == swordSubtypes.twoHanded:
		gridSize = Vector3(25, 3, 9)
	else:
		print("setGridSize() - swordSubtype is mismatch or null!")
	return
