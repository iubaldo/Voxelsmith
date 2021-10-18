extends Resource
class_name ComponentType
# a virtual class defining types of components used for weapon assembly

enum componentTypes { blade, head, guard, handle, pommel }
var componentType
var gridSize: Vector3 # defines the componentType's standard size


# virtual function
# sets the grid size based on the component type and subtypes, if any
func initGridSize() -> void:
	return
