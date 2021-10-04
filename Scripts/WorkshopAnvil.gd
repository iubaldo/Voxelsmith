extends Interactable

# if interacted with, switch to this camera
# smithing code here

# notes:
# to check if a pattern has been fulilled, compare matrices for patternGrid and smithingGrid
#	need to make a voxel comparison function

onready var voxelTemplate = preload("res://Scenes/Smithing/Voxels/Voxel.tscn")
onready var anvilGrid = $TransparentGrid
onready var smithingGridTemplate = preload("res://Scenes/Smithing/SmithingGrid.tscn")
onready var patternGridTemplate = preload("res://Scenes/Smithing/PatternGrid.tscn")

var smithingGrid: SmithingGrid # the currently active smithingGrid, if any
var patternGrid: PatternGrid # the currently active patternGrid, if any

var stepSize: float # constant for converting to a normalized coordinate system for voxels

# smithing variables
var subvoxelMode: bool = false # whether or not to target subvoxels
var selectedVoxel: Voxel = null
var selectedSubvoxel: Subvoxel = null

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
	label3D.visible = true if (isSelected && !isActive) else false
	pass

func _input(event):
	pass


func onActive() -> void:
	workstationCamera.current = true
	anvilGrid.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func onDeactive() -> void:
	anvilGrid.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass


# smithing functions

func addIngot(var ingot: Ingot) -> void:
	if smithingGrid != null && ingot.matType == smithingGrid.matType:
		if smithingGrid.voxelPool == 0:
			smithingGrid.addIngot()
		else:
			smithingGrid.voxelPool += 10
	else:
		# create new smithingGrid using the ingot's materialType
		pass
	pass


# compares active smithingGrid to active patternGrid
# should also update voxels remaining
func checkSmithingCompletion() -> void:
	pass
