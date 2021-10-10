extends Resource
class_name Inventory
# stores physical items as well as handled their insertion/retrieval

var inventory = [] # stores Items
var slots = [] # physical locations of items in inventory

func storeItem(item: Item) -> void:
	if inventory.empty():
		print("storeItem() - inventory is full!")
		return
	
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			item.store(slots[i].get_global_transform())
	return


func retrieveItem(index: int) -> Item:
	if inventory[index] == null:
		print("retrieveItem() - item at index is null!")
		return null
	
	var toReturn = inventory[index]
	inventory[index] = null
	return null
