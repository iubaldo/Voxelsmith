extends Interactable

# if interacted with, switch to this camera
# smithing code here

# notes:
# to check if a pattern has been fulilled, compare matrices for patternGrid and smithingGrid
#	need to make a voxel comparison function

onready var voxelTemplate = preload("res://Scenes/Smithing/Voxels/Voxel.tscn")
onready var smithingGridTemplate = preload("res://Scenes/Smithing/SmithingGrid.tscn")
onready var patternGridTemplate = preload("res://Scenes/Smithing/PatternGrid.tscn")
onready var forgingMaterialTemplate = preload("res://Scripts/Smithing/Materials/ForgingMaterial.gd")
onready var vallumTemplate = preload("res://Scripts/Smithing/Materials/Vallum.gd")
onready var anvilGrid = $AnvilGrid
onready var gridOrigin: Spatial = $GridOrigin
onready var smithingUI: Control = $SmithingUI
onready var powerLabel: Label = $SmithingUI/StrikePowerLabel
onready var strikeTimer: Timer = $strikeTimer # determines how long before strike is cancelled
onready var strikeCDTimer: Timer = $strikeCDTimer # determines cooldown before another strike can be made

var smithingGrid # the currently active smithingGrid, if any
var patternGrid # the currently active patternGrid, if any

const STEP_SIZE: float = 0.1 # constant for converting to a normalized coordinate system for voxels

# smithing variables

var maxStrikePower: int = 500
var strikePower: int = 0
var strikePowerIncreaseRate: int = 500

var pritchelHole: Rect2 = Rect2(5, -1, 1, 3)
var voxelsRemaining: int = 0 # how many unfilled voxels in the pattern (note: a voxel counts as "filled" only if subvoxels also match pattern)

# for use when rotating grid
var cameraForward: Vector3
var cameraBack: Vector3
var cameraLeft: Vector3
var cameraRight: Vector3

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera
	
	cameraForward = -global_transform.basis.z
	cameraBack = global_transform.basis.z
	cameraLeft = -global_transform.basis.x
	cameraRight = global_transform.basis.x
	
	pass

func _process(delta):
	label3D.visible = true if (isSelected && !isActive) else false
	pass
	

func _physics_process(delta):
	
	if isActive && smithingGrid != null:
		if strikePower != 0:
			powerLabel.text = "Strike Power: " + var2str(strikePower)
		else:
			powerLabel.text = ""
			
		if strikeCDTimer.is_stopped():
			if Input.is_action_pressed("primaryAction"):
				if !strikeTimer.is_stopped(): # perform strike
					if strikePower <= 100:
						# some kind of penalty for too light
						pass
					else:
						strike(Globals.selectedVoxel, strikePower)
						strikePower = 0
				else:
					if strikePower < maxStrikePower:
						strikePower = clamp(strikePower + strikePowerIncreaseRate * delta, 0, maxStrikePower)
						
			if Input.is_action_just_released("primaryAction"):
				strikeTimer.start()
	pass

func _input(event):
	# debug controls, remove later
	if Globals.anvilActive && event.is_action_pressed("debug_addIngot"):
		var newIngot = Ingot.new()
		newIngot.forgingMat = forgingMaterialTemplate.new(vallumTemplate.new())
		addIngot(newIngot)
		
	if Globals.anvilActive && smithingGrid != null && strikeCDTimer.is_stopped():
		if event.is_action_pressed("rotateGridCW"):
			rotateGridCW()
		elif event.is_action_pressed("rotateGridCCW"):
			rotateGridCCW()
			
		if event.is_action_pressed("moveForward"):
			moveGrid(1)
		elif event.is_action_pressed("moveRight"):
			moveGrid(2)
		elif event.is_action_pressed("moveBack"):
			moveGrid(3)
		elif event.is_action_pressed("moveLeft"):
			moveGrid(4)
	pass


func onActive() -> void:
	workstationCamera.current = true
	anvilGrid.visible = true
	smithingUI.visible = true
	Globals.anvilActive = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func onDeactive() -> void:
	anvilGrid.visible = false
	smithingUI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.anvilActive = false
	Globals.resetAnvil()
	pass


# smithing functions

func strike(target: Voxel, power: int) -> void:
	if target != null:
		var targetList = [] # list of positions to check
		
		if power <= 200: 	# precise, context-specific
			print("action: precise strike")
			if smithingGrid.isPositionValid(target.gridPosition + cameraForward)\
				 && !smithingGrid.doesVoxelExist(target.gridPosition + cameraForward): # create
				smithingGrid.createVoxel(target.gridPosition + cameraForward)
			else:
				if smithingGrid.isPositionValid(target.gridPosition + cameraBack)\
				 	&&!smithingGrid.doesVoxelExist(target.gridPosition + cameraBack): # draw
					print("action: draw")
					target.draw(cameraForward, Vector3.UP) # replace with cameraUp later
				else: # dish
					print("action: dish")
					target.dish(Vector3.UP) # replace with cameraUp later
			pass
		elif power <= 300: 	# light, 3x3 cross centered on target
			print("action: light strike")
			targetList.push_back(target.gridPosition + cameraForward)
			targetList.push_back(target.gridPosition + cameraLeft)
			targetList.push_back(target.gridPosition)
			targetList.push_back(target.gridPosition + cameraRight)
			targetList.push_back(target.gridPosition + cameraBack)
		elif power <= 400:	# medium, horizontal 1x3 area in front of target
			print("action: medium strike")
			targetList.push_back(target.gridPosition + cameraForward + cameraLeft)
			targetList.push_back(target.gridPosition + cameraForward)
			targetList.push_back(target.gridPosition + cameraForward + cameraRight)
			targetList.push_back(target.gridPosition)
		else: 				# heavy, 3x3 square centered on target
			print("action: heavy strike")
			targetList.push_back(target.gridPosition + cameraForward + cameraLeft)
			targetList.push_back(target.gridPosition + cameraForward)
			targetList.push_back(target.gridPosition + cameraForward + cameraRight)
			targetList.push_back(target.gridPosition + cameraLeft)
			targetList.push_back(target.gridPosition)
			targetList.push_back(target.gridPosition + cameraRight)
			targetList.push_back(target.gridPosition + cameraBack + cameraLeft)
			targetList.push_back(target.gridPosition + cameraBack)
			targetList.push_back(target.gridPosition + cameraBack + cameraRight)
		
		for targetPos in targetList:
			if smithingGrid.isPositionValid(targetPos):
				if smithingGrid.getVoxel(targetPos) == null:
					smithingGrid.createVoxel(targetPos)
					print("created voxel at position " + var2str(targetPos))
				else:
					if pritchelHole.has_point(Vector2(targetPos.x, targetPos.z)):
						smithingGrid.destroyVoxel(targetPos)
					else:
						print("failed to create voxel - voxel already exists at position " + var2str(targetPos))
			else: 
				print("failed to create voxel - target position " + var2str(targetPos) + " invalid")
				
		print("targetPos: " + var2str(target.gridPosition))
		
		for targetPos in targetList:
			if smithingGrid.doesVoxelExist(targetPos) && smithingGrid.getVoxel(targetPos) != null:
				# apply heat loss
				pass
				
		strikeCDTimer.start()
	else:
		print("strike() - target is null!")
	pass


func rotateGridCW() -> void:
	smithingGrid.rotate_y(deg2rad(-90.0))
	
	var temp = cameraForward
	cameraForward = cameraLeft;
	cameraLeft = cameraBack;
	cameraBack = cameraRight;
	cameraRight = temp;
	pass
func rotateGridCCW() -> void:
	smithingGrid.rotate_y(deg2rad(90.0))
	
	var temp = cameraForward
	cameraForward = cameraRight;
	cameraRight = cameraBack;
	cameraBack = cameraLeft;
	cameraLeft = temp;
	pass


func moveGrid(direction: int) -> void:
	match direction:
		1: # up
			if (smithingGrid.translation.z - 1 * STEP_SIZE >= -14 * STEP_SIZE):
				smithingGrid.translation.z += -1 * STEP_SIZE
		2: # right
			if (smithingGrid.translation.x + 1 * STEP_SIZE <= 28 * STEP_SIZE):
				smithingGrid.translation.x += 1 * STEP_SIZE
		3: # down
			if (smithingGrid.translation.z + 1 * STEP_SIZE <= 14 * STEP_SIZE):
				smithingGrid.translation.z += 1 * STEP_SIZE
		4: # left
			if (smithingGrid.translation.x + -1 * STEP_SIZE >= -28 * STEP_SIZE):
				smithingGrid.translation.x += -1 * STEP_SIZE
	pass


func addIngot(ingot: Ingot) -> void:
	if smithingGrid != null && ingot.matType == smithingGrid.matType:
		smithingGrid.voxelPool += 10
	else:
		# create new smithingGrid using the ingot's materialType
		smithingGrid = smithingGridTemplate.instance()
		smithingGrid.initGrid(ingot.forgingMat)
		add_child(smithingGrid)
		smithingGrid.translation = gridOrigin.translation
		smithingGrid.createIngot()
		pass
	pass


# compares active smithingGrid to active patternGrid
# should also update voxels remaining
func checkSmithingCompletion() -> void:
	pass


func _on_strikeTimer_timeout():
	strikePower = 0
	pass


func _on_strikeCDTimer_timeout():
	# make hammer model invisible
	pass 
