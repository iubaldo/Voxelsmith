extends "res://Scripts/Interactable.gd"

# if interacted with, switch to this camera
# forging code here

onready var label3D = $Label3D
onready var workstationCamera = $Camera

func _process(delta):
	label3D.visible = true if (isSelected && !isActive) else false
	pass


func onActive() -> void:
	workstationCamera.current = true
	pass
