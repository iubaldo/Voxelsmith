extends "res://Scripts/Interactable.gd"

# if interacted with, switch to this camera
# smithing code here

onready var label3D = $Label3D
onready var workstationCamera = $Camera
onready var anvilGrid = $TransparentGrid

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
