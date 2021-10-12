extends Spatial
class_name WorkshopScene

onready var player = $Player
onready var freeItems: Spatial = $FreeItems # used to store any items in the physical space not currently being stored elsewhere
onready var workstations: Spatial = $Environment/Workstations
onready var anvil: WorkshopAnvil = $Environment/Workstations/WorkshopAnvil
onready var forge: WorkshopForge = $Environment/Workstations/WorkshopForge

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return

func _input(event):
	if event.is_action_pressed("freeMouse") && Globals.activeWorkstation == null:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return
