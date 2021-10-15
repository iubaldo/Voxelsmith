extends Interactable
class_name Workstation

export onready var workstationData: WorkstationData
onready var label3D
onready var workstationCamera # might replace with a spatial that tells the camera to move there later

enum workstationTypes { anvil, forge, pourer, oreRefinery, quenchingTank, grindstone }
var workstationType

func _ready():
	return


func initWorkstationData() -> void:
	return


func initInternalInventory() -> void:
	return
