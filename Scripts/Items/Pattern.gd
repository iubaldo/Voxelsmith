extends Item
class_name Pattern
# the physical item holding a pattern

onready var patternMesh = $PatternMesh.mesh


func _ready():
	add_to_group("Items")
	return


func createItemData(newComponentType: ComponentType) -> void:
	var newPatternData: PatternData = Globals.patternDataTemplate.new()
	newPatternData.componentType = newComponentType
	setItemData(newPatternData)
	itemData.initPatternData()
	return


func setModel() -> void:
	match itemData.componentType.componentType:
		ComponentType.componentTypes.blade:
			match itemData.componentType.componentSubtype:
				BladeComponent.componentSubtypes.ohSword:
					patternMesh.mesh = Globals.ohBladePatternModel
				BladeComponent.componentSubtypes.thSword:
					patternMesh = Globals.thBladePatternModel
				BladeComponent.componentSubtypes.dagger:
					patternMesh = Globals.daggerBladePatternModel
				BladeComponent.componentSubtypes.spear:
					patternMesh = Globals.spearBladePatternModel
		ComponentType.componentTypes.head:
			match itemData.componentType.componentSubtype:
				HeadComponent.componentSubtypes.axe:
					patternMesh = Globals.axeHeadPatternModel
				HeadComponent.componentSubtypes.mace:
					patternMesh = Globals.maceHeadPatternModel
				HeadComponent.componentSubtypes.hammer:
					patternMesh = Globals.hammerHeadPatternModel
		ComponentType.componentTypes.guard:
			match itemData.componentType.componentSubtype:
				GuardComponent.componentSubtypes.ohGuard:
					patternMesh = Globals.ohGuardPatternModel
				GuardComponent.componentSubtypes.thGuard:
					patternMesh = Globals.thGuardPatternModel
				GuardComponent.componentSubtypes.daggerGuard:
					patternMesh = Globals.daggerGuardPatternModel
		ComponentType.componentTypes.handle:
			match itemData.componentType.componentSubtype:
				HandleComponent.componentSubtypes.oh:
					patternMesh = Globals.ohHandlePatternModel
				HandleComponent.componentSubtypes.hnh:
					patternMesh = Globals.hnhHandlePatternModel
				HandleComponent.componentSubtypes.th:
					patternMesh = Globals.thHandlePatternModel
				HandleComponent.componentSubtypes.medium:
					patternMesh = Globals.medHandlePatternModel
				HandleComponent.componentSubtypes.long:
					patternMesh = Globals.longHandlePatternModel
		ComponentType.componentTypes.pommel:
			patternMesh = Globals.pommelPatternModel
		_:
			print("componentType is mismatch or null!")
	return
