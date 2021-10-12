extends Resource
class_name Inventory
# stores items and their physical locations, as well as handles their insertion/retrieval

var allowedItemTypes = [] # stores itemType enums as ints to compare
var inventory = [] # stores items
var slots = [] # stores spatials that represent the physical locations of items in inventory

signal storedItem() # tells playerInventory to drop its heldItem before we store it
signal retrievedItem(item) # tells playerInventory to grab the item


# if slots are full, swaps out the last item instead
# might change this to store at target index later
func storeItem(item: Item) -> void:
	if inventory.empty():
		print("storeItem() - inventory is full!")
		return
	if !allowedItemTypes.has(item.itemData.itemType):
		print("storeItem() - " + var2str(item.itemData.itemTypes) + " is a non-whitelisted itemType!")
		return
	
	print("storing item")
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			emit_signal("storedItem")
			item.store(slots[i].get_global_transform())
			return
	
	print("inventory is full! swapping last item...")
	swapItem(item, inventory[-1])
	return


# deletes item from inventory and calls grabItem() from playerInventory
func retrieveItem(index: int) -> void:
	if inventory[index] == null:
		print("retrieveItem() - item at index is null!")
		return
	
	print("retrieving item")
	emit_signal("retrievedItem", inventory[index])
	inventory[index] = null
	return


# swaps an item in the inventory with another item
# replaces item at index with swapItem
func swapItem(swapItem: Item, index: int) -> void:
	retrieveItem(index)
	inventory[index] = swapItem
	emit_signal("storedItem")
	swapItem.store(slots[index].get_global_transform())
	return
