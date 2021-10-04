extends Interactable

# if interacted with, switch to this camera
# smithing code here

onready var voxel = preload("res://Scenes/Smithing/Voxels/Voxel.tscn")
onready var anvilGrid = $TransparentGrid
onready var smithingGrid = preload("res://Scenes/Smithing/SmithingGrid.tscn")

# smithing variables
var maxStrikePower = 500
var strikePower = 0
var strikePowerIncreaseRate = 100

var voxelPool = 0

var mousecastLength = 50

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera

func _process(delta):
	label3D.visible = true if (isSelected && !isActive) else false

func onActive() -> void:
	workstationCamera.current = true
	anvilGrid.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func onDeactive() -> void:
	anvilGrid.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

# smithing functions

# make this take an ingot item as an arugment later
func addIngot(var matType: MaterialType) -> void:
	if voxelPool == 0:
		# create ingot
		pass
	else:
		voxelPool += 25
	pass
