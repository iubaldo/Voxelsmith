extends Spatial
class_name PlayerInventory

onready var itemHolder: Spatial = $ItemHolder

var playerInventory = [] # currently unused, but would be used to store a larger inventory of items
var heldItem: Item = null
var maxDistFromPlayer: float = 2.5

func _physics_process(delta):
	if heldItem:
		var a = itemHolder.get_global_transform().origin
		var b = heldItem.get_global_transform().origin
		heldItem.set_linear_velocity((a - b) * 10)
	
	if heldItem&& itemHolder.get_global_transform().origin.distance_to(heldItem.get_global_transform().origin) \
		> maxDistFromPlayer:
		print("heldItem is too far from player, dropping!")
		dropHeldItem()
	return


func grabItem(item: Item) -> void:
	if heldItem != null:
		dropHeldItem()
	
	item.store(itemHolder.transform)
	item.itemize()
	item.axis_lock_angular_x = true
	item.axis_lock_angular_z = true
	heldItem = item
	return


func dropHeldItem() -> void:
	if heldItem == null:
		print("dropHeldItem() - heldItem is null!")
		return
	
	heldItem.itemize()
	heldItem.apply_central_impulse(Vector3.ZERO) # stops the item from sleeping
	heldItem.axis_lock_angular_x = false
	heldItem.axis_lock_angular_z = false
	heldItem = null
	return
