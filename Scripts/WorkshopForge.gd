extends "res://Scripts/Interactable.gd"

# if interacted with, switch to this camera
# forging code here

onready var label3D = $Sprite3D
onready var workstationCamera = $Camera

func _process(delta):
	if !isActive:
		label3D.visible = true if isSelected else false


func onActive():
	workstationCamera.current = true
