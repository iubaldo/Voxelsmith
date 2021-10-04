extends Node
class_name Subvoxel
# note: subvoxels should inherit their material from their parent voxel

onready var outlineMesh = $OutlineMesh

var parent: Voxel

# note: these should only call when subvoxelMode is true and anvil is active
func _on_SubvoxelHitbox_mouse_entered():
	if WorkshopAnvil.subvoxelMode && WorkshopAnvil.isActive:
		WorkshopAnvil.selectedSubvoxel = self
		outlineMesh.visible = true
	pass
func _on_SubvoxelHitbox_mouse_exited():
	if WorkshopAnvil.subvoxelMode && WorkshopAnvil.isActive:
		WorkshopAnvil.selectedSubvoxel = self
		outlineMesh.visible = false
	pass
