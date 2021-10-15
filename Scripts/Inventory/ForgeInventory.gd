extends Inventory
class_name ForgeInventory

func _init():
	items.resize(4)
	slots.resize(4)
	lastStoredIndex.resize(4)
	allowedItemTypes = [ItemData.itemTypes.ingot, ItemData.itemTypes.crucible, ItemData.itemTypes.smithingGrid]
	return
