extends Interactable
class_name WorkshopForge
# if interacted with, switch to this camera
# forging code here

var inventory

onready var slot1Origin: Spatial = $InternalInventory/Slot1
onready var slot2Origin: Spatial = $InternalInventory/Slot2
onready var slot3Origin: Spatial = $InternalInventory/Slot3
onready var slot4Origin: Spatial = $InternalInventory/Slot4

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera
	workstationType = workstationTypes.forge
	return

func _process(delta):
	label3D.visible = true if (Globals.selectedWorkstation != null && Globals.selectedWorkstation == self \
		&& !Globals.isAnvilActive()) else false
	return


func onActive() -> void:
	workstationCamera.current = true
	return


func storeItem(item: Item) -> void:
	if !(item || item is SmithingGrid):
		print("storeItem - invalid itemType!")
		return
	
	
	
	return
