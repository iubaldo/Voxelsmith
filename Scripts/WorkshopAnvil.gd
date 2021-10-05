extends Interactable

# if interacted with, switch to this camera
# smithing code here

# notes:
# to check if a pattern has been fulilled, compare matrices for patternGrid and smithingGrid
#	need to make a voxel comparison function

onready var voxelTemplate = preload("res://Scenes/Smithing/Voxels/Voxel.tscn")
onready var smithingGridTemplate = preload("res://Scenes/Smithing/SmithingGrid.tscn")
onready var patternGridTemplate = preload("res://Scenes/Smithing/PatternGrid.tscn")
onready var forgingMaterialTemplate = preload("res://Scripts/Smithing/Materials/ForgingMaterial.gd")
onready var vallumTemplate = preload("res://Scripts/Smithing/Materials/Vallum.gd")
onready var anvilGrid = $AnvilGrid
onready var gridOrigin = $GridOrigin

var smithingGrid # the currently active smithingGrid, if any
var patternGrid # the currently active patternGrid, if any

const STEP_SIZE: float = 0.1 # constant for converting to a normalized coordinate system for voxels

# smithing variables

var maxStrikePower: int = 500
var strikePower: int = 0
var strikePowerIncreaseRate: int = 100

var voxelsRemaining: int = 0 # how many unfilled voxels in the pattern (note: a voxel counts as "filled" only if subvoxels also match pattern)

var mousecastLength: int = 50

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera
	pass

func _process(delta):
	if (isSelected && !isActive):
		label3D.visible = true
	else:
		label3D.visible = false
	
	#label3D.visible = true if (isSelected && !isActive) else false
	pass

func _input(event):
	if event.is_action_pressed("debug_addIngot"):
		var newIngot = Ingot.new()
		newIngot.forgingMat = forgingMaterialTemplate.new(vallumTemplate.new())
		addIngot(newIngot)
	pass


func onActive() -> void:
	workstationCamera.current = true
	anvilGrid.visible = true
	Globals.anvilActive = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func onDeactive() -> void:
	anvilGrid.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.anvilActive = false
	Globals.resetAnvil()
	pass


# smithing functions

func addIngot(var ingot: Ingot) -> void:
	if smithingGrid != null && ingot.matType == smithingGrid.matType:
		smithingGrid.voxelPool += 10
	else:
		# create new smithingGrid using the ingot's materialType
		smithingGrid = smithingGridTemplate.instance()
		smithingGrid.initGrid(ingot.forgingMat)
		add_child(smithingGrid)
		smithingGrid.translation = gridOrigin.translation
		smithingGrid.createIngot()
		pass
	pass


# compares active smithingGrid to active patternGrid
# should also update voxels remaining
func checkSmithingCompletion() -> void:
	pass
