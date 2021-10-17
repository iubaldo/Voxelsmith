extends Workstation
class_name WorkshopForge

onready var slot0Origin: Spatial = $InternalInventory/Slot0
onready var slot1Origin: Spatial = $InternalInventory/Slot1
onready var slot2Origin: Spatial = $InternalInventory/Slot2
onready var slot3Origin: Spatial = $InternalInventory/Slot3

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera
	workstationType = workstationTypes.forge
	
	if !workstationData:
		initWorkstationData()
	get_tree().call_group("PlayerInventory", "connectInventorySignals", workstationData.inventory)
	return


func initWorkstationData() -> void:
	var newForgeData: ForgeData = Globals.forgeDataTemplate.new()
	newForgeData.heat = 0
	newForgeData.targetHeat = 0
	newForgeData.maxHeat = 10000
	newForgeData.heatAccumulation = 3
	newForgeData.heatDissipation = 3
	workstationData = newForgeData
	initInternalInventory()
	return


func initInternalInventory() -> void:
	var newForgeInventory = Globals.forgeInventoryTemplate.new()
	workstationData.inventory = newForgeInventory
	workstationData.inventory.slots[0] = slot0Origin
	workstationData.inventory.slots[1] = slot1Origin
	workstationData.inventory.slots[2] = slot2Origin
	workstationData.inventory.slots[3] = slot3Origin
	return


func _process(delta):
	label3D.visible = true if (Globals.selectedWorkstation != null && Globals.selectedWorkstation == self \
		&& !Globals.isAnvilActive()) else false
	
	return


func _physics_process(delta):
	for item in workstationData.inventory.items:
		if item:
			item.itemData.forgingMat.accumulateHeat(workstationData.targetHeat, delta)
			if item.melt:
				workstationData.inventory.removeItem(item)
	
	if workstationData.targetHeat > workstationData.heat:
		workstationData.accumulateHeat(delta)
	
	workstationData.dissipateHeat(delta)
	return


func onActive() -> void:
	workstationCamera.current = true
	return


func blowBellows() -> void:
	workstationData.targetHeat += 200
	return
