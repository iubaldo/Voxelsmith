extends Inventory
class_name AnvilInventory
# note: disallow a pattern or ingot to be added while a smithingGrid is on the anvil
# note: return pattern to player inventory after creating a smithingGrid
# slots:
#	0: smithingGrid
#	1: pattern
#	2: ingot

func _init():
	inventory.resize(3)
	slots.resize(3)
	allowedItemTypes = [ItemData.itemTypes.smithingGrid, ItemData.itemTypes.pattern, ItemData.itemTypes.ingot]
	return


# override
func storeItem(item: Item) -> void:
	if inventory.empty():
		print("storeItem() - inventory is full!")
		return
	if !allowedItemTypes.has(item.itemData.itemType):
		print("storeItem() - " + var2str(item.itemData.itemTypes) + " is a non-whitelisted itemType!")
		return
	
	match (item.itemData.itemType):
		ItemData.itemTypes.smithingGrid:
			if !inventory[0]: 
				inventory[0] = item
				emit_signal("storedItem")
				item.store(slots[0].get_global_transform())
			else:
				swapItem(item, 0)
		ItemData.itemTypes.pattern:
			if !inventory[1]:
				inventory[1] = item
				emit_signal("storedItem")
				item.store(slots[1].get_global_transform())
			else:
				swapItem(item, 1)
		ItemData.itemTypes.ingot:
			if !inventory[2]:
				inventory[2] = item
				emit_signal("storedItem")
				item.store(slots[2].get_global_transform())
			else: 
				swapItem(item, 2)
	return
