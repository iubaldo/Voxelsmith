extends Interactable
class_name Workstation

export onready var internalInventory: Inventory
onready var label3D
onready var workstationCamera # might replace with a spatial that tells the camera to move there later

enum workstationTypes { anvil, forge, pourer, oreRefinery, quenchingTank, grindstone }
var workstationType

func _ready():
	initInternalInventory()
	get_tree().call_group("PlayerInventory", "connectInventorySignals", internalInventory)
	return


func initInternalInventory() -> void:
	return
