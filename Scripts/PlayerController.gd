extends KinematicBody

# This script handles player controls and interactions such as movement
# note: does not govern controls for workstations

onready var playerCamera = $CameraPivot/Camera
onready var interactRaycast = $InteractRayCast

var velocity = Vector3()
var maxSpeed = 5
const GRAVITY = -30

var mouseSensitivity = 0.003 # radians/pixel, for each pixel the mouse moves, camera rotates by 0.003 radians
var usingController = false

var selectedWorkstation = null
var activeWorkstation = null

func _process(delta):
	if activeWorkstation == null:
		if interactRaycast.is_colliding():
			if selectedWorkstation != null && interactRaycast.get_collider() != selectedWorkstation:
				selectedWorkstation.isSelected = false
			selectedWorkstation = interactRaycast.get_collider()
			selectedWorkstation.isSelected = true
		else:
			if selectedWorkstation != null:
				selectedWorkstation.isSelected = false
	pass


func _physics_process(delta):
	if activeWorkstation == null:
		velocity.y += GRAVITY * delta
		var targetVelocity = handleMoveInput() * maxSpeed
		velocity.x = targetVelocity.x
		velocity.z = targetVelocity.z
		
		velocity = move_and_slide(velocity, Vector3.UP, true)
	pass


func _unhandled_input(event):
	if activeWorkstation == null:
		if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouseSensitivity)
			$CameraPivot.rotate_x(-event.relative.y * mouseSensitivity)
			$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, -1.2, 1.2)
		
	if event.is_action_pressed("interact"):
		if selectedWorkstation != null && activeWorkstation == null:
			activeWorkstation = selectedWorkstation
			selectedWorkstation.isActive = true
			selectedWorkstation.onActive()
	if event.is_action_pressed("ui_cancel") && activeWorkstation != null:
		selectedWorkstation.isActive = false
		activeWorkstation.onDeactive()
		activeWorkstation = null
		playerCamera.current = true
	pass


func handleMoveInput() -> Vector3:
	var moveVector = Vector3.ZERO
	
#	if !usingController:
#		var inputVector = Vector3(Input.get_action_strength("MoveLeft") - Input.get_action_strength("MoveRight"), \
#		0, Input.get_action_strength("moveForward") - Input.get_action_strength("MoveRight"))
#
#		moveVector = inputVector.normalized()
#	else:
#		pass
	
	if Input.is_action_pressed("moveForward"):
		moveVector += -global_transform.basis.z
	if Input.is_action_pressed("moveBack"):
		moveVector += global_transform.basis.z
	if Input.is_action_pressed("moveLeft"):
		moveVector += -global_transform.basis.x
	if Input.is_action_pressed("moveRight"):
		moveVector += global_transform.basis.x
		
	moveVector = moveVector.normalized()
	return moveVector
