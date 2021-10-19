extends Node

# voxels
onready var voxelTemplate = load("res://Scenes/Voxel.tscn")

# items
onready var ingotTemplate = load("res://Scenes/Items/Ingot.tscn")
onready var smithingGridTemplate = load("res://Scenes/Items/SmithingGrid.tscn")
onready var patternTemplate = load("res://Scenes/Items/Pattern.tscn")
onready var componentTemplate = load("res://Scenes/Items/Component.tscn")

# item data
onready var forgingMaterialTemplate = load("res://Scripts/Items/ItemData/ForgingMaterial.gd")
onready var ingotDataTemplate = load("res://Scripts/Items/ItemData/IngotData.gd")
onready var sgDataTemplate = load("res://Scripts/Items/ItemData/SmithingGridData.gd")
onready var patternDataTemplate = load("res://Scripts/Items/ItemData/Patterns/PatternData.gd")
onready var componentDataTemplate = load("res://Scripts/Items/ItemData/Components/ComponentData.gd")

# material types
onready var vallumTemplate = load("res://Scripts/Items/ItemData/Materials/MaterialTypes/Vallum.gd")

# component types
onready var componentTypeTemplate = load("res://Scripts/Items/ItemData/Components/ComponentType.gd")
onready var bladeComponentTemplate = load("res://Scripts/Items/ItemData/Components/ComponentTypes/BladeComponent.gd")
onready var guardComponentTemplate = load("res://Scripts/Items/ItemData/Components/ComponentTypes/GuardComponent.gd")
onready var handleComponentTemplate = load("res://Scripts/Items/ItemData/Components/ComponentTypes/HandleComponent.gd")
onready var headomponentTemplate = load("res://Scripts/Items/ItemData/Components/ComponentTypes/HeadComponent.gd")
onready var pommelComponentTemplate = load("res://Scripts/Items/ItemData/Components/ComponentTypes/PommelComponent.gd")

# pattern models
onready var axeHeadPatternModel = load("res://Models/Patterns/axeheadpattern.obj")
onready var blankPatternModel = load("res://Models/Patterns/blankpattern.obj")
onready var daggerGuardPatternModel = load("res://Models/Patterns/daggerguardpattern.obj")
onready var daggerBladePatternModel = load("res://Models/Patterns/daggerbladepattern.obj")
onready var hammerHeadPatternModel = load("res://Models/Patterns/hammerheadpattern.obj")
onready var hnhHandlePatternModel = load("res://Models/Patterns/hnhhandlepattern.obj")
onready var longHandlePatternModel = load("res://Models/Patterns/longhandlepattern.obj")
onready var maceHeadPatternModel = load("res://Models/Patterns/maceheadpattern.obj")
onready var medHandlePatternModel = load("res://Models/Patterns/medhandlepattern.obj")
onready var ohBladePatternModel = load("res://Models/Patterns/ohbladepattern.obj")
onready var ohGuardPatternModel = load("res://Models/Patterns/ohguardpattern.obj")
onready var ohHandlePatternModel = load("res://Models/Patterns/ohhandlepattern.obj")
onready var pommelPatternModel = load("res://Models/Patterns/pommelpattern.obj")
onready var spearBladePatternModel = load("res://Models/Patterns/spearbladepattern.obj")
onready var thBladePatternModel = load("res://Models/Patterns/thbladepattern.obj")
onready var thGuardPatternModel = load("res://Models/Patterns/thguardpattern.obj")
onready var thHandlePatternModel = load("res://Models/Patterns/thhandlepattern.obj")

# game data
onready var inventoryTemplate = load("res://Scripts/Inventory/Inventory.gd")
onready var anvilInventoryTemplate = load("res://Scripts/Inventory/AnvilInventory.gd")
onready var forgeInventoryTemplate = load("res://Scripts/Inventory/ForgeInventory.gd")
onready var anvilDataTemplate = load("res://Scripts/Interactable/Workstations/WorkstationData/AnvilData.gd")
onready var forgeDataTemplate = load("res://Scripts/Interactable/Workstations/WorkstationData/ForgeData.gd")


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


# item spawning / data creation methods
func createSmithingGrid(forgingMat: ForgingMaterial, patternData: PatternData) -> SmithingGrid:
	var newSmithingGrid: SmithingGrid = smithingGridTemplate.instance()
	newSmithingGrid.createItemData(forgingMat, patternData)
	return newSmithingGrid

func createIngot(forgingMat: ForgingMaterial) -> Ingot:
	var newIngot: Ingot = ingotTemplate.instance()
	newIngot.createItemData(forgingMat)
	return newIngot

func createPattern(componentType: ComponentType) -> Pattern:
	var newPattern: Pattern = patternTemplate.instance()
	newPattern.createItemData(componentType)
	newPattern.setModel()
	return newPattern

func createComponent(componentType: ComponentType, forgingMat: ForgingMaterial) -> Component:
	var newComponent: Component = componentTemplate.instance()
	newComponent.createItemData(componentType, forgingMat)
	return newComponent

func createComponentType(componentType: int, componentSubtype: int) -> ComponentType:
	var newComponentType: ComponentType = componentTypeTemplate.new()
	newComponentType.componentType = componentType
	newComponentType.componentSubtype = componentSubtype
	newComponentType.initGridSize()
	return newComponentType

func createForgingMaterial(matType: MaterialType) -> ForgingMaterial:
	var newForgingMat: ForgingMaterial = forgingMaterialTemplate.new()
	newForgingMat.initForgingMaterial(matType)
	return newForgingMat
