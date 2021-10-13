extends Resource
class_name Inventory
# stores items and their physical locations, as well as handles their insertion/retrieval

var allowedItemTypes = [] # stores itemType enums as ints to compare
var inventory = [] # stores items
var slots = [] # stores spatials that represent the physical locations of items in inventory
var lastStoredIndex: int = 0

signal storedItem(itemize) # calls dropHeldItem() on playerInventory before we store it
signal retrievedItem(item) # calls grabItem(item) on playerInventory
signal toggledCheckDist() # toggles checkDist on playerInventory so we don't prematurely drop an item while moving it


# if slots are full, swaps out the last item instead
# might change this to store at target index later
# can also store last stored index to swap that out instead
func storeItem(item: Item) -> void:
	if !allowedItemTypes.has(item.itemData.itemType):
		print("storeItem() - " + var2str(item.itemData.itemTypes) + " is a non-whitelisted itemType!")
		return
	
	if inventory.has(null): # if an unfilled slot exists
		print("storing item")
		var index = inventory.find(null)
		inventory[index] = item
		lastStoredIndex = index
		emit_signal("storedItem", false)
		item.store(slots[index].get_global_transform())
	else:
		print("inventory is full! swapping last item...")
		swapItem(item, lastStoredIndex)
	return


# deletes item from inventory and calls grabItem() from playerInventory
func retrieveItem(index: int) -> void:
	if inventory[index] == null:
		print("retrieveItem() - item at index is null!")
		return
	if inventory.empty():
		print("retrieveItem() - inventory is empty!")
		return
	
	print("retrieving item from index " + var2str(lastStoredIndex))
	emit_signal("retrievedItem", inventory[lastStoredIndex])
	inventory[lastStoredIndex] = null
	return


# swaps an item in the inventory with another item
# replaces item at index with swapItem
func swapItem(swapItem: Item, index: int) -> void:
	print("swapping items")
	emit_signal("storedItem", false)
	var retrievedItem: Item = inventory[index]
	inventory[index] = swapItem
	swapItem.store(slots[index].get_global_transform())
	emit_signal("retrievedItem", retrievedItem)
	return
