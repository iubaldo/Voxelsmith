extends RigidBody
class_name Item
# physical items that can be carried around and stored in inventories

export onready var itemData: ItemData # the item's data 
onready var collider: CollisionShape # disabled when being stored or lerping

var targetTransform: Transform
var moveToTarget: bool = false
var resetTransform: bool = false
var lerpSpeed: float = 5.0

func _ready():
	add_to_group("Items")
	return


# supposed to be a virtual function, but gdscript doesn't support overloading so ¯\_(ツ)_/¯
# func createItemData() -> void:
#	 return


func setItemData(newItemData: ItemData) -> void:
	itemData = newItemData
	return


func _physics_process(delta):
	if !targetTransform && !(moveToTarget || resetTransform):
		return
	
	if moveToTarget:
		var oldScale = scale
		global_transform = global_transform.interpolate_with(targetTransform, 0.1)
		scale = oldScale
	if global_transform.origin.distance_to(targetTransform.origin) < 0.001:
		moveToTarget = false
		
	if resetTransform:
		global_transform = targetTransform
		resetTransform = false
	return


# stores the item into an inventory
# converts to static, changes collider layer, and lerps to target location
# ideally use a "time" value to determine how long it takes to lerp to target
func store(targetPos: Transform) -> void:
	mode = RigidBody.MODE_STATIC
	set_collision_layer_bit(5, false)
	set_collision_layer_bit(6, true)
	
	targetTransform = targetPos
	moveToTarget = true
	return


# converts item to worldspace, allowing it to act as a rigidbody
func itemize() -> void:
	mode = RigidBody.MODE_RIGID
	set_collision_layer_bit(5, true)
	set_collision_layer_bit(6, false)
	
	targetTransform = global_transform
	var workshopScene = get_tree().get_root().get_node("WorkshopScene")
	get_parent().remove_child(self)
	workshopScene.freeItems.add_child(self)
	resetTransform = true
	return
