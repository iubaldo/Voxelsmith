extends Node

var subvoxelMode: bool = false # whether or not to target subvoxels
var anvilActive: bool = false
var forgeActive: bool = false

var selectedSubvoxel: Subvoxel = null
var selectedVoxel: Voxel = null

func resetAnvil() -> void:
	subvoxelMode = false
	resetTargets()
	pass


func toggleSubvoxelMode() -> void:
	print("toggled subvoxel mode -> " + var2str(subvoxelMode))
	subvoxelMode = !subvoxelMode
	resetTargets()
	get_tree().call_group("Subvoxels", "toggleSubvoxelCollider")
	get_tree().call_group("Voxels", "toggleVoxelCollider")


func resetTargets() -> void:
	if selectedVoxel != null:
		selectedVoxel.outlineMesh.visible = false
		selectedVoxel = null
	if selectedSubvoxel != null:
		selectedSubvoxel.outlineMesh.visible = false
		selectedSubvoxel = null
	pass
