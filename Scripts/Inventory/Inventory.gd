extends Resource
class_name Inventory
# stores items and their physical locations, as well as handles their insertion/retrieval

var allowedItemTypes = [] # stores itemType enums as ints to compare
var items = [] # stores items
var slots = [] # stores spatials that represent the physical locations of items in inventory
var lastStoredIndex = []

signal storedItem(itemize) # calls dropHeldItem() on playerInventory before we store it
signal retrievedItem(item) # calls grabItem(item) on playerInventory


# if slots are full, swaps out the last item instead
# might change this to store at target index later
# can also store last stored index to swap that out instead
func storeItem(item: Item) -> void:
	if !allowedItemTypes.has(item.itemData.itemType):
		print("storeItem() - " + var2str(item.itemData.itemTypes) + " is a non-whitelisted itemType!")
		return
	
	if items.has(null): # if an unfilled slot exists
		print("storing item")
		var index = items.find(null)
		items[index] = item
		lastStoredIndex.push_front(index)
		emit_signal("storedItem", false)
		item.store(slots[index].get_global_transform())
	else:
		print("inventory is full! swapping last item...")
		swapItem(item, lastStoredIndex.front())
	return


# deletes item from inventory and calls grabItem() from playerInventory
func retrieveItem(index: int) -> void:
	if items[index] == null:
		print("retrieveItem() - item at index is null!")
		return
	if items.empty():
		print("retrieveItem() - inventory is empty!")
		return
	
	print("retrieving item from index " + var2str(lastStoredIndex.front()))
	emit_signal("retrievedItem", items[lastStoredIndex.front()])
	items[lastStoredIndex.front()] = null
	lastStoredIndex.pop_front()
	return


# swaps an item in the inventory with another item
# replaces item at index with swapItem
func swapItem(swapItem: Item, index: int) -> void:
	print("swapping items")
	emit_signal("storedItem", false)
	var retrievedItem: Item = items[index]
	items[index] = swapItem
	swapItem.store(slots[index].get_global_transform())
	emit_signal("retrievedItem", retrievedItem)
	return
