extends Inventory
class_name AnvilInventory
# note: disallow a pattern or ingot to be added while a smithingGrid is on the anvil
# note: return pattern to player inventory after creating a smithingGrid
# slots:
#	0: smithingGrid
#	1: pattern
#	2: ingot

func _init():
	items.resize(3)
	slots.resize(3)
	lastStoredIndex.resize(3)
	allowedItemTypes = [ItemData.itemTypes.smithingGrid, ItemData.itemTypes.pattern, ItemData.itemTypes.ingot]
	return


# override
func storeItem(item: Item) -> void:
	if !items.has(null):
		print("storeItem() - inventory is full!")
		return
	if !allowedItemTypes.has(item.itemData.itemType):
		print("storeItem() - " + var2str(item.itemData.itemTypes) + " is a non-whitelisted itemType!")
		return
	if items[0] && (item.itemData.itemType == ItemData.itemTypes.pattern || item.itemData.itemType == ItemData.itemTypes.ingot):
		print("storeItem() - can't store an ingot or pattern while a smithingGrid is stored!")
		return
	
	match (item.itemData.itemType):
		ItemData.itemTypes.smithingGrid:
			if !items[0]: 
				items[0] = item
				emit_signal("storedItem", false)
				item.store(slots[0].get_global_transform())
				item.get_parent().remove_child(item)
				slots[0].add_child(item)
				lastStoredIndex.push_front(0)
				var _placeholder = item.connect("melted", self, "removeItem")
				print("storing smithingGrid")
			else:
				swapItem(item, 0)
		ItemData.itemTypes.pattern:
			if !items[1]:
				items[1] = item
				emit_signal("storedItem", false)
				item.store(slots[1].get_global_transform())
				item.get_parent().remove_child(item)
				slots[1].add_child(item)
				lastStoredIndex.push_front(1)
				print("storing pattern")
			else:
				swapItem(item, 1)
		ItemData.itemTypes.ingot:
			if !items[2]:
				items[2] = item
				emit_signal("storedItem", false)
				item.store(slots[2].get_global_transform())
				item.get_parent().remove_child(item)
				slots[2].add_child(item)
				lastStoredIndex.push_front(2)
				var _placeholder = item.connect("melted", self, "removeItem")
				print("storing ingot")
			else: 
				swapItem(item, 2)
	return
