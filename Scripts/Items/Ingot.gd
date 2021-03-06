extends Item
class_name Ingot
# an item that can be used to begin smithing or add voxels to an existing smithingGrid
# note: maybe have a different color gradient for heating up ingots

onready var meltTimer: Timer = $MeltTimer
onready var mat: SpatialMaterial = $IngotMesh.get_surface_material(0)

var melt: bool = false

func _ready():
	add_to_group("Items")
	add_to_group("Heatable")
	collider = $CollisionShape
	return


func _physics_process(delta):
	mat.albedo_color = itemData.forgingMat.getMaterialColor()
	itemData.forgingMat.dissipateHeat(delta)
	
	if itemData.forgingMat.heat > itemData.forgingMat.matType.smeltingTemp && meltTimer.time_left == 0:
		print("start melt countdown")
		meltTimer.start()

	# if we fall back below smelting temp, abort
	if meltTimer.time_left > 0 && itemData.forgingMat.heat <= itemData.forgingMat.matType.smeltingTemp:
		print("abort melt countdown")
		meltTimer.stop()
	return


func createItemData(newForgingMat: ForgingMaterial) -> void:
	var newIngotData: IngotData = Globals.ingotDataTemplate.new()
	newIngotData.forgingMat = newForgingMat
	setItemData(newIngotData)
	return


# causes the ingot to start falling through the ground slowly before it despawns once out of sight
func _on_MeltTimer_timeout():
	itemize()
	collider.disabled = true
	gravity_scale = 0.1
	melt = true
	emit_signal("melted", self)
	return


func _on_VisibilityNotifier_screen_exited():
	if melt:
		self.queue_free()
	return
