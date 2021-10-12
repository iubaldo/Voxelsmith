extends KinematicBody

# This script handles player controls and interactions such as movement
# note: does not govern controls for workstations

onready var playerCamera = $CameraPivot/Camera
onready var playerInventory = $CameraPivot/PlayerInventory
onready var interactRaycast = $CameraPivot/Camera/InteractRayCast
onready var playerCrosshair = $CameraPivot/Camera/CenterContainer/Crosshair

var workshopScene: WorkshopScene

var velocity = Vector3()
var maxSpeed = 5
const GRAVITY = -30

var mouseSensitivity = 0.003 # radians/pixel, for each pixel the mouse moves, camera rotates by 0.003 radians
var usingController = false


func _ready():
	workshopScene = get_parent()
	return


func _process(delta):
	if Globals.activeWorkstation == null:
		if interactRaycast.is_colliding():
			if interactRaycast.get_collider().is_in_group("Items") || interactRaycast.get_collider().is_in_group("Interactable"):
				playerCrosshair.visible = true
			
			if Globals.selectedWorkstation != null && interactRaycast.get_collider() != Globals.selectedWorkstation:
				Globals.selectedWorkstation = null
			Globals.selectedWorkstation = interactRaycast.get_collider()
		else:
			playerCrosshair.visible = false
			if Globals.selectedWorkstation != null:
				Globals.selectedWorkstation = null
	else:
		playerCrosshair.visible = false
	return


func _physics_process(delta):
	if Globals.activeWorkstation == null:
		velocity.y += GRAVITY * delta
		var targetVelocity = handleMoveInput() * maxSpeed
		velocity.x = targetVelocity.x
		velocity.z = targetVelocity.z
		
		velocity = move_and_slide(velocity, Vector3.UP, true)
	return


func _unhandled_input(event):
	# when not currently using a workstation
	if !Globals.activeWorkstation:
		# move camera with mouse
		if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouseSensitivity)
			$CameraPivot.rotate_x(-event.relative.y * mouseSensitivity)
			$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, -1.2, 1.2)
			
		# debug method to spawn a vallum ingot
		if event.is_action_pressed("debug_addIngot"):
			var newForgingMat: ForgingMaterial = Globals.createForgingMaterial(Globals.vallumTemplate.new())
			var newIngot: Ingot = Globals.createIngot(newForgingMat)
			
			workshopScene.freeItems.add_child(newIngot)
			newIngot.global_transform.origin = playerCamera.global_transform.origin + playerCamera.global_transform.basis.z * -4
		
	# workstation activation/deactivation
	if event.is_action_pressed("interact"):
		if Globals.selectedWorkstation && !Globals.activeWorkstation:
			Globals.activeWorkstation = Globals.selectedWorkstation
			Globals.selectedWorkstation.onActive()
	if event.is_action_pressed("ui_cancel") && Globals.activeWorkstation:
		Globals.activeWorkstation.onDeactive()
		Globals.activeWorkstation = null
		playerCamera.current = true
		
	# secondary action on workstations
	if event.is_action_pressed("secondaryAction") && !Globals.activeWorkstation:
		if Globals.selectedWorkstation:
			if playerInventory.heldItem: # swap item
				Globals.selectedWorkstation.internalInventory.storeItem(playerInventory.heldItem)
			else: # store items
				if Globals.isAnvilSelected():
					if workshopScene.anvil.anvilSmithingGrid:
						workshopScene.anvil.internalInventory.retrieveItem(0)
					elif workshopScene.anvil.anvilPattern:
						workshopScene.anvil.internalInventory.retrieveItem(1)
					elif workshopScene.anvil.anvilIngot:
						workshopScene.anvil.internalInventory.retrieveItem(2)
	
	if event.is_action_pressed("secondaryAction") && interactRaycast.get_collider() \
		&& interactRaycast.get_collider().is_in_group("Items"):
		playerInventory.grabItem(interactRaycast.get_collider())
	if event.is_action_pressed("dropItem") && playerInventory.heldItem:
		playerInventory.dropHeldItem()
	return


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
