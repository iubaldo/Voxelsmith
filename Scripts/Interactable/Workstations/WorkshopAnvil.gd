extends Workstation
class_name WorkshopAnvil
# notes:
# to check if a pattern has been fulilled, compare matrices for patternGrid and smithingGrid
#	need to make a voxel comparison function

onready var anvilGrid = $AnvilGrid
onready var gridOrigin: Spatial = $InternalInventory/GridOrigin
onready var patternOrigin: Spatial = $InternalInventory/PatternOrigin
onready var ingotOrigin: Spatial = $InternalInventory/IngotOrigin
onready var smithingUI: Control = $SmithingUI
onready var powerLabel: Label = $SmithingUI/StrikePowerLabel
onready var strikeTimer: Timer = $StrikeTimer # determines how long before strike is cancelled
onready var strikeCDTimer: Timer = $StrikeCDTimer # determines cooldown before another strike can be made

var anvilIngot: Ingot # the currently active ingot, if any
var anvilSmithingGrid: SmithingGrid # the currently active smithingGrid, if any
var anvilPattern: Pattern # the currently active pattern, if any

const STEP_SIZE: float = 0.1 # constant for converting to a normalized coordinate system for voxels
var gridBounds: Rect2 = Rect2(-14 * STEP_SIZE, -28 * STEP_SIZE, 29 * STEP_SIZE, 49 * STEP_SIZE)
var anvilBounds: Rect2 = Rect2(-6 * STEP_SIZE, -2 * STEP_SIZE, 13 * STEP_SIZE, 5 * STEP_SIZE)
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
	workstationType = workstationTypes.anvil
	
	cameraForward = -global_transform.basis.z
	cameraBack = global_transform.basis.z
	cameraLeft = -global_transform.basis.x
	cameraRight = global_transform.basis.x
	cameraUp = global_transform.basis.y
	
	._ready()
	return


func initInternalInventory() -> void:
	var newAnvilInventory = Globals.anvilInventoryTemplate.new()
	internalInventory = newAnvilInventory
	internalInventory.slots[0] = gridOrigin
	internalInventory.slots[1] = patternOrigin
	internalInventory.slots[2] = ingotOrigin
	return


func _process(delta):
	anvilSmithingGrid = internalInventory.inventory[0]
	anvilPattern = internalInventory.inventory[1]
	anvilIngot = internalInventory.inventory[2]
	zoomCamera(delta)
	label3D.visible = true if (Globals.selectedWorkstation != null && Globals.selectedWorkstation == self \
		&& !Globals.isAnvilActive()) else false
	return
	

func _physics_process(delta):
	if Globals.isAnvilActive() && anvilSmithingGrid != null:
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
	return

func _unhandled_input(event):
	# debug action, remove later
	# simulates creating a smithing grid with an existing ingot + pattern
	if Globals.isAnvilActive() && !anvilSmithingGrid && event.is_action_pressed("debug_addIngot"):
		# create forgingMat (would be inherited from anvilIngot)
		var newForgingMat: ForgingMaterial = Globals.createForgingMaterial(Globals.vallumTemplate.new())
		
		# create componentType (would be inherited from anvilPattern)
		var newComponentType: ComponentType = Globals.bladeSwordComponentTemplate.new()
		newComponentType.swordSubtype = BladeSwordComponent.swordSubtypes.oneHanded
		newComponentType.initGridSize()
		
		# create pattern (would be anvilPattern)
		var newPattern: Pattern = Globals.createPattern(newComponentType)
		
		# create smithingGrid
		var newSmithingGrid: SmithingGrid = Globals.createSmithingGrid(newForgingMat, newPattern.itemData)
		add_child(newSmithingGrid)
		internalInventory.storeItem(newSmithingGrid)
		
		print("debug addIngot - created new smithingGrid")
		
	if Globals.isAnvilActive() && anvilSmithingGrid != null && strikeCDTimer.is_stopped():
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
	return


func onActive() -> void:
	workstationCamera.current = true
	anvilGrid.visible = true
	smithingUI.visible = true
	Globals.activeWorkstation = self
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	return
func onDeactive() -> void:
	anvilGrid.visible = false
	smithingUI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.activeWorkstation = null
	Globals.resetAnvil()
	return


func strike(target, power: int) -> void: # target is either voxel or subvoxel
	if target != null:
		if !anvilBounds.has_point(Vector2(stepify(target.translation.x + anvilSmithingGrid.translation.x - 0.25, 0.1), \
			stepify(target.translation.z + anvilSmithingGrid.translation.z - 0.05, 0.1))): 
			print(var2str(Vector2(stepify(target.translation.x + anvilSmithingGrid.translation.x - 0.25, 0.1), \
			stepify(target.translation.z + anvilSmithingGrid.translation.z - 0.05, 0.1))))
			print("strike() - target outside anvil grid!")
			return
		if target is Voxel:
			var targetList = [] # list of positions to check
			
			if power <= 100:
				# some kind of penalty for striking too lightly
				pass 
			if power <= 200: 	# precise, context-specific
				print("action: precise strike")
				
				# punch
				if pritchelHole.has_point(Vector2(stepify(target.translation.x + anvilSmithingGrid.translation.x - 0.25, 0.1), \
					stepify(target.translation.z + anvilSmithingGrid.translation.z - 0.05, 0.1))): 
					print("action: punch")
					anvilSmithingGrid.destroyVoxel(target.gridPosition)
					return
				
				var ahead: bool = anvilSmithingGrid.isPositionValid(target.gridPosition + cameraForward)\
					 && anvilSmithingGrid.doesVoxelExist(target.gridPosition + cameraForward)
				var behind: bool = anvilSmithingGrid.isPositionValid(target.gridPosition + cameraBack)\
					 && anvilSmithingGrid.doesVoxelExist(target.gridPosition + cameraBack)
					
				if !behind: # draw
					print("action: draw")
					target.draw(cameraForward, cameraUp)
				elif !ahead: # create
					anvilSmithingGrid.createVoxel(target.gridPosition + cameraForward)
				elif ahead:
					print("action: dish")
					target.dish(cameraUp)
					
					var neighbors = []
					neighbors.push_back(target.gridPosition + cameraForward)
					neighbors.push_back(target.gridPosition + cameraLeft)
					neighbors.push_back(target.gridPosition + cameraRight)
					neighbors.push_back(target.gridPosition + cameraBack)
					
					for targetPos in neighbors:
						if anvilSmithingGrid.isPositionValid(targetPos) && anvilSmithingGrid.getVoxel(targetPos) != null:
							if target.dishUp && anvilSmithingGrid.getVoxel(targetPos).dishUp\
								|| target.dishDown && anvilSmithingGrid.getVoxel(targetPos).dishDown:
								anvilSmithingGrid.getVoxel(targetPos).connectDish(targetPos - target.gridPosition, cameraUp)
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
				if anvilSmithingGrid.isPositionValid(targetPos):
					if anvilSmithingGrid.getVoxel(targetPos) == null:
						anvilSmithingGrid.createVoxel(targetPos)
						print("created voxel at position " + var2str(targetPos))
					else:
						if pritchelHole.has_point(Vector2(targetPos.x, targetPos.z)):
							anvilSmithingGrid.destroyVoxel(targetPos)
						else:
							print("failed to create voxel - voxel already exists at position " + var2str(targetPos))
				else: 
					print("failed to create voxel - target position " + var2str(targetPos) + " invalid")
					
			# print("targetPos: " + var2str(target.gridPosition))
			
			for targetPos in targetList:
				if anvilSmithingGrid.doesVoxelExist(targetPos) && anvilSmithingGrid.getVoxel(targetPos) != null:
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
	return


func rotateGridCW() -> void:
	anvilSmithingGrid.rotate_y(deg2rad(-90.0))
	
	var temp = cameraForward
	cameraForward = cameraLeft;
	cameraLeft = cameraBack;
	cameraBack = cameraRight;
	cameraRight = temp;
	return
func rotateGridCCW() -> void:
	anvilSmithingGrid.rotate_y(deg2rad(90.0))
	
	var temp = cameraForward
	cameraForward = cameraRight;
	cameraRight = cameraBack;
	cameraBack = cameraLeft;
	cameraLeft = temp;
	return
func flipGridX() -> void:
	anvilSmithingGrid.rotate_x(deg2rad(180.0))
	
	var temp = cameraForward
	cameraForward = cameraBack
	cameraBack = temp
	cameraUp *= -1
	return
func flipGridZ() -> void:
	anvilSmithingGrid.rotate_z(deg2rad(180.0))
	
	var temp = cameraLeft
	cameraLeft = cameraRight
	cameraRight = temp
	cameraUp *= -1
	return


func moveGrid(direction: int) -> void:
	match direction:
		1: # up
			if gridBounds.has_point(Vector2((anvilSmithingGrid.translation + Vector3.FORWARD * STEP_SIZE).x, \
			(anvilSmithingGrid.translation + Vector3.FORWARD * STEP_SIZE).z)):
				anvilSmithingGrid.translation += Vector3.FORWARD * STEP_SIZE
			else:
				print("moveGrid() - target out of bounds, can't move up!")
		2: # right
			if gridBounds.has_point(Vector2((anvilSmithingGrid.translation + Vector3.RIGHT * STEP_SIZE).x, \
			(anvilSmithingGrid.translation + Vector3.RIGHT * STEP_SIZE).z)):
				anvilSmithingGrid.translation += Vector3.RIGHT * STEP_SIZE
			else:
				print("moveGrid() - target out of bounds, can't move right!")
		3: # down
			if gridBounds.has_point(Vector2((anvilSmithingGrid.translation + Vector3.BACK * STEP_SIZE).x, \
			(anvilSmithingGrid.translation + Vector3.BACK * STEP_SIZE).z)):
				anvilSmithingGrid.translation += Vector3.BACK * STEP_SIZE
			else:
				print("moveGrid() - target out of bounds, can't move down!")
		4: # left
			if gridBounds.has_point(Vector2((anvilSmithingGrid.translation + Vector3.LEFT * STEP_SIZE).x, \
			(anvilSmithingGrid.translation + Vector3.LEFT * STEP_SIZE).z)):
				anvilSmithingGrid.translation += Vector3.LEFT * STEP_SIZE
			else:
				print("moveGrid() - target out of bounds, can't move left!")
	return


func addIngot(newIngot: Ingot) -> void:
	if anvilSmithingGrid:
		if newIngot.ingotData.forgingMat.material.matType == anvilSmithingGrid.sgData.forgingMat.material.matType:
			anvilSmithingGrid.sgData.voxelPool += 10
			print("addIngot - increased voxel pool")
		else:
			print("addIngot - incompatible materialTypes!")
			print("smithingGrid materialType: " + var2str(anvilSmithingGrid.sgData.forgingMat.material.matType))
			print("ingot materialType: " + var2str(newIngot.ingotData.forgingMat.material.matType))
			return
	elif anvilPattern:
		internalInventory.storeItem(newIngot)
		createSmithingGrid()
		print("addIngot - created new smithingGrid")
	else:
		print("addIngot() - no existing grid or pattern!")
	return


# creates a new smithing grid using the anvil's ingot and pattern
func createSmithingGrid() -> void:
	if !anvilIngot:
		print("createSmithingGrid() - ingot is null! ")
		return
	if !anvilPattern:
		print("createSmithingGrid() - pattern is null! ")
		return
	
	var newSmithingGrid: SmithingGrid = Globals.createSmithingGrid(anvilIngot.itemData.forgingMat, anvilPattern.itemData)
	add_child(newSmithingGrid)
	internalInventory.storeItem(newSmithingGrid)
	
	anvilIngot.queue_free() # delete the ingot used to create the smithingGrid
	internalInventory.inventory[2] = null
	return


# compares active smithingGrid to active patternGrid
# should also update voxels remaining
func checkSmithingCompletion() -> void:
	return


func _on_strikeTimer_timeout():
	strikePower = 0
	return


func _on_strikeCDTimer_timeout():
	# make hammer model invisible
	return


func zoomCamera(delta: float) -> void:
	var newZoom = clamp(workstationCamera.fov + (zoomSpeed * zoomDir * delta), minZoom, maxZoom)
	workstationCamera.fov = newZoom
	
	zoomDir *= zoomSpeedDamp
	if abs(zoomDir) <= 0.0001:
		zoomDir = 0
	return


func resetZoom(delta: float) -> void:
	return
