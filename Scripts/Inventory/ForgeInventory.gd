extends Inventory
class_name ForgeInventory

func _init():
	allowedItemTypes = [ItemData.itemTypes.ingot, ItemData.itemTypes.crucible, ItemData.itemTypes.smithingGrid]
