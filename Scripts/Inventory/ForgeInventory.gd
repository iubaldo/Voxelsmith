extends Inventory
class_name ForgeInventory

func _init():
	inventory.resize(4)
	slots.resize(4)
	allowedItemTypes = [ItemData.itemTypes.ingot, ItemData.itemTypes.crucible, ItemData.itemTypes.smithingGrid]
	return
