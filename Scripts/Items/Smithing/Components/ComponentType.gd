extends Resource
class_name ComponentType
# describes the kind of component this componentItem or smithingGrid is using

enum componentTypes { blade, guard, handle, pommel }
var compType
var gridSize: Vector3 # defines the componentType's standard size


# sets the grid size based on the component type and subtypes, if any
func setGridSize() -> void:
	return
