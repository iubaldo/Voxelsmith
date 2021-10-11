extends Resource
class_name Inventory
# stores items and their physical locations, as well as handles their insertion/retrieval

var allowedItemTypes = [] # stores itemType enums as ints to compare
var inventory = [] # stores Items
var slots = [] # physical locations of items in inventory

signal storedItem() # tells playerInventory to drop its heldItem before we store it
signal retrievedItem(item) # tells playerInventory to grab the item

func storeItem(item: Item) -> void:
	if inventory.empty():
		print("storeItem() - inventory is full!")
		return
	if !allowedItemTypes.has(item.itemData.itemTypes):
		print("storeItem() - non-whitelisted itemType!")
		return
	
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			emit_signal("storedItem")
			item.store(slots[i].get_global_transform())
			return
	return


# deletes item from inventory and returns, used with grabItem(item)
func retrieveItem(index: int) -> void:
	if inventory[index] == null:
		print("retrieveItem() - item at index is null!")
		return
	
	emit_signal("retrievedItem", inventory[index])
	inventory[index] = null
	return


# swaps an item in the inventory with another item
func swapItem(item: Item, index: int) -> void:
	retrieveItem(index)
	inventory[index] = item
	emit_signal("storedItem")
	item.store(slots[index].get_global_transform())
	return
