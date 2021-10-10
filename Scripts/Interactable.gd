extends Spatial
class_name Interactable

onready var label3D
onready var workstationCamera

enum workstationTypes { anvil, forge }
var workstationType

func _ready():
	add_to_group("Interactable")
	return

func _process(delta):
	return

func onActive():
	return

func onDeactive():
	return
