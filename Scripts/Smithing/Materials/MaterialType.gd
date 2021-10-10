extends Resource
class_name MaterialType
# a virtual class defining types of materials used for forging

# constant attributes
onready var colorGradient: Gradient
onready var temperGradient: Gradient

enum materialTypes { Vallum, Viridium, Ostinium, Sitrium, Albanite, Custom }
var matType
var matName: String

var heatResistance: int # range(-10, 10), determines how long to heat up/cool down
var smeltingTemp: int # determines max heat before melting
var forgingTemp: int # determines min heat needed for forge or engrave
var minNormalizationTemp: int
var maxNormalizationTemp: int
var minQuenchTemp: int
var maxQuenchTemp: int
var minTemperingRange: int
var maxTemperingRange: int

# variable attributes
var hardness: int # range (1, 100), determines max sharpness
var density: int # range (1, 100), determines hammer strength required to shape
var weight: int # range (1, 100), determines final product's weight by (final weight = # of subvoxels * 0.04 * weight * density)
var toughness: int # range (1, 100), determines final product's durability
