extends Interactable

# if interacted with, switch to this camera
# forging code here

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera

func _process(delta):
	label3D.visible = true if (isSelected && !isActive) else false
	pass


func onActive() -> void:
	workstationCamera.current = true
	pass
