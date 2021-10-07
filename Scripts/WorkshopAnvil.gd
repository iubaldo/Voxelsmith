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
var gridBounds: Rect2 = Rect2(-14 * STEP_SIZE, -28 * STEP_SIZE, 29 * STEP_SIZE, 49 * STEP_SIZE)
var anvilBounds: Rect2 = Rect2(-7 * STEP_SIZE, 3 * STEP_SIZE, 15 * STEP_SIZE, 6 * STEP_SIZE)
var pritchelHole: Rect2 = Rect2(5 * STEP_SIZE, -1 * STEP_SIZE, 1 * STEP_SIZE, 3 * STEP_SIZE)

# striking
var maxStrikePower: int = 500
var strikePower: int = 0
var strikePowerIncreaseRate: int = 500

# how many unfilled voxels in the pattern remain (note: a voxel only counts as "filled" when it matches the pattern)
var voxelsRemaining: int = 0 

# reference vectors, used when rotating/flipping grid
var cameraForward: Vector3
var cameraBack: Vector3
var cameraLeft: Vector3
var cameraRight: Vector3
var cameraUp: Vector3

# camera zoom
var defaultZoom: float = 70
var zoomDir: float = 0 # -1 for zoom in, 1 for zoom out, 0 for no zoom
export (int, 0, 179) var minZoom = 25
export (int, 0, 179) var maxZoom = 90
export (float, 0, 1000, 0.1) var zoomSpeed = 150
export (float, 0, 1, 0.1) var zoomSpeedDamp = 0.8

func _ready():
	label3D = $Label3D
	workstationCamera = $Camera
	
	cameraForward = -global_transform.basis.z
	cameraBack = global_transform.basis.z
	cameraLeft = -global_transform.basis.x
	cameraRight = global_transform.basis.x
	cameraUp = global_transform.basis.y
	
	pass

func _process(delta):
	zoomCamera(delta)
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
						if !Globals.subvoxelMode && Globals.selectedVoxel != null:
							strike(Globals.selectedVoxel, strikePower)
						elif Globals.subvoxelMode && Globals.selectedSubvoxel != null:
							strike(Globals.selectedSubvoxel, strikePower)
						strikePower = 0
				else:
					if strikePower < maxStrikePower:
						strikePower = clamp(strikePower + strikePowerIncreaseRate * delta, 0, maxStrikePower)
						
			if Input.is_action_just_released("primaryAction"):
				strikeTimer.start()
	pass

func _unhandled_input(event):
	# debug controls, remove later
	if Globals.anvilActive && event.is_action_pressed("debug_addIngot"):
		var newIngot = Ingot.new()
		newIngot.forgingMat = forgingMaterialTemplate.new(vallumTemplate.new())
		addIngot(newIngot)
		
	if Globals.anvilActive && smithingGrid != null && strikeCDTimer.is_stopped():
		if event.is_action_pressed("toggleSubvoxelMode"):
			Globals.toggleSubvoxelMode()
		
		# grid manipulation
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
			
		if event.is_action_pressed("flipGridX"):
			flipGridX()
		elif event.is_action_pressed("flipGridZ"):
			flipGridZ()
			
		# camera
		if event.is_action_pressed("resetZoom"):
			workstationCamera.fov = defaultZoom
		if event.is_action_released("zoomIn"):
			zoomDir = -1
		elif event.is_action_released("zoomOut"):
			zoomDir = 1
	pass


func onActive() -> void:
	workstationCamera.current = true
	anvilGrid.visible = true
	smithingUI.visible = true
	Globals.anvilActive = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
func onDeactive() -> void:
	anvilGrid.visible = false
	smithingUI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.anvilActive = false
	Globals.resetAnvil()
	pass


func strike(target, power: int) -> void: # target is either voxel or subvoxel
	if target != null:
		if target is Voxel:
			var targetList = [] # list of positions to check
			
			if power <= 100:
				# some kind of penalty for striking too lightly
				pass 
			if power <= 200: 	# precise, context-specific
				print("action: precise strike")
				
				# punch
				if pritchelHole.has_point(Vector2(stepify(target.translation.x + smithingGrid.translation.x - 0.25, 0.1), \
					stepify(target.translation.z + smithingGrid.translation.z - 0.05, 0.1))): 
					print("action: punch")
					smithingGrid.destroyVoxel(target.gridPosition)
					return
				
				var ahead: bool = smithingGrid.isPositionValid(target.gridPosition + cameraForward)\
					 && smithingGrid.doesVoxelExist(target.gridPosition + cameraForward)
				var behind: bool = smithingGrid.isPositionValid(target.gridPosition + cameraBack)\
					 && smithingGrid.doesVoxelExist(target.gridPosition + cameraBack)
					
				if !behind: # draw
					print("action: draw")
					target.draw(cameraForward, cameraUp)
				elif !ahead: # create
					smithingGrid.createVoxel(target.gridPosition + cameraForward)
				elif ahead:
					print("action: dish")
					target.dish(cameraUp)
					
					var neighbors = []
					neighbors.push_back(target.gridPosition + cameraForward)
					neighbors.push_back(target.gridPosition + cameraLeft)
					neighbors.push_back(target.gridPosition + cameraRight)
					neighbors.push_back(target.gridPosition + cameraBack)
					
					for targetPos in neighbors:
						if smithingGrid.isPositionValid(targetPos) && smithingGrid.getVoxel(targetPos) != null:
							if target.dishUp && smithingGrid.getVoxel(targetPos).dishUp\
								|| target.dishDown && smithingGrid.getVoxel(targetPos).dishDown:
								smithingGrid.getVoxel(targetPos).connectDish(targetPos - target.gridPosition, cameraUp)
								target.connectDish(-(targetPos - target.gridPosition), cameraUp)
								print("connected dish")
						
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
					
			# print("targetPos: " + var2str(target.gridPosition))
			
			for targetPos in targetList:
				if smithingGrid.doesVoxelExist(targetPos) && smithingGrid.getVoxel(targetPos) != null:
					# apply heat loss
					pass
			pass
		elif target is Subvoxel:
			if power <= 100:
				# some kind of penalty for striking too lightly
				pass
			elif power <= 200:
				target.parentVoxel.destroySubvoxel(target.gridPosition)
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
func flipGridX() -> void:
	smithingGrid.rotate_x(deg2rad(180.0))
	
	var temp = cameraForward
	cameraForward = cameraBack
	cameraBack = temp
	cameraUp *= -1
	pass
func flipGridZ() -> void:
	smithingGrid.rotate_z(deg2rad(180.0))
	
	var temp = cameraLeft
	cameraLeft = cameraRight
	cameraRight = temp
	cameraUp *= -1
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
	if smithingGrid != null && ingot.matType == smithingGrid.matType: # null error, fix later
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


func zoomCamera(delta: float) -> void:
	var newZoom = clamp(workstationCamera.fov + (zoomSpeed * zoomDir * delta), minZoom, maxZoom)
	workstationCamera.fov = newZoom
	
	zoomDir *= zoomSpeedDamp
	if abs(zoomDir) <= 0.0001:
		zoomDir = 0
	pass


func resetZoom(delta: float) -> void:
	pass
