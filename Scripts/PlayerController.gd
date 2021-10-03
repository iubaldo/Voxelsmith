extends KinematicBody

# This script handles player controls and interactions such as movement

onready var playerCamera = $CameraPivot/Camera

var velocity = Vector3()
var maxSpeed = 5
const GRAVITY = -30

var mouseSensitivity = 0.003 # radians/pixel, for each pixel the mouse moves, camera rotates by 0.003 radians
var usingController = false

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var targetVelocity = handleMoveInput() * maxSpeed
	velocity.x = targetVelocity.x
	velocity.z = targetVelocity.z
	
	velocity = move_and_slide(velocity, Vector3.UP, true)


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
	

func _unhandled_input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouseSensitivity)
		$CameraPivot.rotate_x(-event.relative.y * mouseSensitivity)
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, -1.2, 1.2)
