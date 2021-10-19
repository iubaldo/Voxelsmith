extends KinematicBody

# This script handles player controls and interactions such as movement
# note: does not govern controls for workstations

onready var playerCamera = $CameraPivot/Camera
onready var playerInventory = $CameraPivot/PlayerInventory
onready var interactRaycast = $CameraPivot/Camera/InteractRayCast
onready var playerCrosshair = $CameraPivot/Camera/PlayerUI/CrosshairContainer/Crosshair
onready var contextLabels = $CameraPivot/Camera/PlayerUI/ContextLabelContainer
onready var debugHeatLabel = $CameraPivot/Camera/PlayerUI/ContextLabelContainer/DebugHeatLabel
onready var grabTimer = $GrabTimer

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
	if !Globals.activeWorkstation:
		if interactRaycast.is_colliding() && interactRaycast.get_collider():
			if interactRaycast.get_collider().is_in_group("Items") || interactRaycast.get_collider().is_in_group("Interactable"):
				playerCrosshair.visible = true
				contextLabels.visible = true
				if interactRaycast.get_collider().is_in_group("Heatable"): # debug only, remove later
					debugHeatLabel.visible = true
					debugHeatLabel.text = "Heat: " + var2str(stepify(interactRaycast.get_collider().itemData.forgingMat.heat, 0.01))
			
			if Globals.selectedWorkstation != null && interactRaycast.get_collider() != Globals.selectedWorkstation:
				Globals.selectedWorkstation = null
			Globals.selectedWorkstation = interactRaycast.get_collider()
		else:
			playerCrosshair.visible = false
			contextLabels.visible = false
			debugHeatLabel.visible = false
			if Globals.selectedWorkstation != null:
				Globals.selectedWorkstation = null
		
		if Globals.isForgeSelected():
			contextLabels.visible = true
			debugHeatLabel.visible = true
			debugHeatLabel.text = "Forge Heat: " + var2str(stepify(Globals.selectedWorkstation.workstationData.heat, 0.01)) + \
									"\nTarget Heat: " + var2str(stepify(Globals.selectedWorkstation.workstationData.targetHeat, 0.01))
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
		elif event.is_action_pressed("debug_spawnPattern"):
			var newComponentType: ComponentType = Globals.createComponentType(ComponentType.componentTypes.blade, BladeComponent.componentSubtypes.ohSword)
			var newPattern: Pattern = Globals.createPattern(newComponentType)
			workshopScene.freeItems.add_child(newPattern)
			newPattern.global_transform.origin = playerCamera.global_transform.origin + playerCamera.global_transform.basis.z * -4
			pass
		
	# workstation activation/deactivation
	if event.is_action_pressed("interact"):
		if Globals.selectedWorkstation && !Globals.activeWorkstation:
			Globals.activeWorkstation = Globals.selectedWorkstation
			Globals.selectedWorkstation.onActive()
	if event.is_action_pressed("ui_cancel") && Globals.activeWorkstation:
		Globals.activeWorkstation.onDeactive()
		Globals.activeWorkstation = null
		playerCamera.current = true
	
	if event.is_action_pressed("debug_blowBellows") && Globals.isForgeSelected():
		print("blowing bellows")
		Globals.selectedWorkstation.blowBellows()
		
	# secondary action on workstations
	if event.is_action_pressed("secondaryAction") && !Globals.activeWorkstation && Globals.selectedWorkstation:
		if playerInventory.heldItem: # store item
			Globals.selectedWorkstation.workstationData.inventory.storeItem(playerInventory.heldItem)
		else: # retrieve items
			if Globals.selectedWorkstation.workstationData.inventory.lastStoredIndex.front() != null:
				if Globals.isAnvilSelected():
					if workshopScene.anvil.workstationData.inventory.items[0]:
						workshopScene.anvil.workstationData.inventory.retrieveItem(0)
					elif workshopScene.anvil.workstationData.inventory.items[1]:
						workshopScene.anvil.workstationData.inventory.retrieveItem(1)
					elif workshopScene.anvil.workstationData.inventory.items[2]:
						workshopScene.anvil.workstationData.inventory.retrieveItem(2)
				else:			
					Globals.selectedWorkstation.workstationData.inventory.retrieveItem(Globals.selectedWorkstation.workstationData.inventory.lastStoredIndex[0])
			else:
				print("inventory is empty!")
	elif event.is_action_pressed("secondaryAction") && interactRaycast.get_collider() \
		&& interactRaycast.get_collider().is_in_group("Items"):
		playerInventory.grabItem(interactRaycast.get_collider())
	elif event.is_action_pressed("dropItem") && playerInventory.heldItem:
		playerInventory.dropHeldItem(true)
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
