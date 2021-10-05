extends Node

var subvoxelMode: bool = false # whether or not to target subvoxels
var anvilActive: bool = false
var forgeActive: bool = false

var selectedSubvoxel: Subvoxel = null
var selectedVoxel: Voxel = null

func resetAnvil() -> void:
	subvoxelMode = false
	selectedSubvoxel = null
	selectedVoxel = null

func toggleSubvoxelMode() -> void:
	get_tree().call_group("Subvoxels", "toggleSubvoxelCollider")
