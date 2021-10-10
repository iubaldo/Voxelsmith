extends Resource
class_name ItemData
# a virtual class defining item information to be saved between game loads

enum itemTypes { oreChunk, ingot, smithingGrid, component, pattern, mold, weapon }
var itemType
var itemName: String
