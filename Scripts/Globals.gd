extends Node

# items
onready var ingotTemplate = load("res://Scenes/Items/Ingot.tscn")
onready var smithingGridTemplate = load("res://Scenes/Smithing/SmithingGrid.tscn")
onready var voxelTemplate = load("res://Scenes/Smithing/Voxels/Voxel.tscn")
onready var patternTemplate = load("res://Scenes/Smithing/Patterns/Pattern.tscn")

# components
onready var bladeSwordComponentTemplate = load("res://Scripts/Items/Smithing/Components/BladeSwordComponent.gd")

# materials
onready var vallumTemplate = load("res://Scripts/Smithing/Materials/Vallum.gd")

# item data
onready var forgingMaterialTemplate = load("res://Scripts/Smithing/Materials/ForgingMaterial.gd")
onready var ingotDataTemplate = load("res://Scripts/Items/Smithing/IngotData.gd")
onready var sgDataTemplate = load("res://Scripts/Items/Smithing/SmithingGridData.gd")
onready var patternDataTemplate = load("res://Scripts/Items/Smithing/Patterns/PatternData.gd")

# game data
onready var inventoryTemplate = load("res://Scripts/Inventory/Inventory.gd")
onready var anvilInventoryTemplate = load("res://Scripts/Inventory/AnvilInventory.gd")
onready var forgeInventoryTemplate = load("res://Scripts/Inventory/ForgeInventory.gd")

var subvoxelMode: bool = false # whether or not to target subvoxels
var selectedWorkstation: Workstation = null
var activeWorkstation: Workstation = null

var selectedSubvoxel: Subvoxel = null
var selectedVoxel: Voxel = null

func resetAnvil() -> void:
	subvoxelMode = false
	resetTargets()
	return


func toggleSubvoxelMode() -> void:
	print("toggled subvoxel mode -> " + var2str(subvoxelMode))
	subvoxelMode = !subvoxelMode
	resetTargets()
	get_tree().call_group("Subvoxels", "toggleSubvoxelCollider")
	get_tree().call_group("Voxels", "toggleVoxelCollider")
	return


func resetTargets() -> void:
	if selectedVoxel != null:
		selectedVoxel.outlineMesh.visible = false
		selectedVoxel = null
	if selectedSubvoxel != null:
		selectedSubvoxel.outlineMesh.visible = false
		selectedSubvoxel = null
	return


func isAnvilActive() -> bool:
	if activeWorkstation != null && activeWorkstation.workstationType == Workstation.workstationTypes.anvil:
		return true
	return false
func isAnvilSelected() -> bool:
	if selectedWorkstation != null && selectedWorkstation.workstationType == Workstation.workstationTypes.anvil:
		return true
	return false
func isForgeActive() -> bool:
	if activeWorkstation != null && activeWorkstation.workstationType == Workstation.workstationTypes.forge:
		return true
	return false
func isForgeSelected() -> bool:
	if selectedWorkstation != null && selectedWorkstation.workstationType == Workstation.workstationTypes.forge:
		return true
	return false
