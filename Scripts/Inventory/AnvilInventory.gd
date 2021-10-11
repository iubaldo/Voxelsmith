extends Inventory
class_name AnvilInventory
# note: disallow a pattern or ingot to be added while a smithingGrid is on the anvil
# note: return pattern to player inventory after creating a smithingGrid

func _init():
	allowedItemTypes = [ItemData.itemTypes.smithingGrid, ItemData.itemTypes.pattern, ItemData.itemTypes.ingot]
	return


# override
func storeItem(item: Item) -> void:
	if inventory.empty():
		print("storeItem() - inventory is full!")
		return
	if !allowedItemTypes.has(item.itemData.itemTypes):
		print("storeItem() - non-whitelisted itemType!")
		return
	
	match (item.itemData.itemTypes):
		ItemData.itemTypes.smithingGrid:
			if !inventory[0]: 
				inventory[0] = item
			else:
				#swap
				pass
	return
