extends MaterialType
class_name Vallum

# an iron-like forging material

func _init():
	matType = materialTypes.Vallum
	
	heatResistance = 5 # range(-10, 10), determines how long to heat up/cool down
	smeltingTemp = 2000 # determines max heat before melting
	forgingTemp = 1000 # determines min heat needed for forge or engrave
	minNormalizationTemp = 900
	maxNormalizationTemp = 990
	minQuenchTemp = 800
	maxQuenchTemp = 890
	minTemperingRange = 500
	maxTemperingRange = 790

	colorGradient = preload("res://Materials/Voxel/Gradients/Forging/VallumForgingGradient.tres")
	temperGradient = preload("res://Materials/Voxel/Gradients/Forging/VallumForgingGradient.tres")

	# these attributes can change during smithing
	hardness = 50 # range (1, 100), determines max sharpness
	density = 50 # range (1, 100), determines hammer strength required to shape
	weight = 50 # range (1, 100), determines final product's weight by (final weight = # of subvoxels * 0.04 * weight * density)
	toughness = 50 # range (1, 100), determines final product's durability
	
	pass
