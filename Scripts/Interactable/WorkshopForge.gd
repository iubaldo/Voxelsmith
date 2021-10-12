extends Workstation
class_name WorkshopForge
# if interacted with, switch to this camera
# forging code here

onready var slot0Origin: Spatial = $InternalInventory/Slot0
onready var slot1Origin: Spatial = $InternalInventory/Slot1
onready var slot2Origin: Spatial = $InternalInventory/Slot2
onready var slot3Origin: Spatial = $InternalInventory/Slot3

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera
	workstationType = workstationTypes.forge
	._ready()
	return


func initInternalInventory() -> void:
	var newForgeInventory = Globals.forgeInventoryTemplate.new()
	internalInventory = newForgeInventory
	internalInventory.slots[0] = slot0Origin
	internalInventory.slots[1] = slot1Origin
	internalInventory.slots[2] = slot2Origin
	internalInventory.slots[3] = slot3Origin
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
