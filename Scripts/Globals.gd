extends Node

var subvoxelMode: bool = false # whether or not to target subvoxels
var anvilActive: bool = false
var forgeActive: bool = false

var selectedSubvoxel: Subvoxel = null
var selectedVoxel: Voxel = null

func resetAnvil() -> void:
	subvoxelMode = false
	if selectedVoxel != null:
		selectedVoxel.outlineMesh.visible = false
	if selectedSubvoxel != null:
		selectedSubvoxel.outlineMesh.visible = false
		
	selectedSubvoxel = null
	selectedVoxel = null

func toggleSubvoxelMode() -> void:
	subvoxelMode = !subvoxelMode
	get_tree().call_group("Subvoxels", "toggleSubvoxelCollider")
	get_tree().call_group("Voxels", "toggleVoxelCollider")
