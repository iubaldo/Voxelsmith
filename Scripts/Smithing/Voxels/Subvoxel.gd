extends Node
class_name Subvoxel
# note: subvoxels should inherit their material from their parent voxel

onready var outlineMesh = $OutlineMesh
onready var collider = $SubvoxelMesh/SubvoxelHitbox/CollisionShape

var parent: Voxel
var gridPosition: Vector3

func _ready():
	add_to_group("Subvoxels")
	pass


func toggleSubvoxelCollider() -> void:
	collider.disabled = !collider.disabled
	pass


# note: these should only call when subvoxelMode is true and anvil is active
func _on_SubvoxelHitbox_mouse_entered():
	if Globals.subvoxelMode && Globals.anvilActive:
		Globals.selectedSubvoxel = self
		outlineMesh.visible = true
	pass
func _on_SubvoxelHitbox_mouse_exited():
	if Globals.subvoxelMode && Globals.anvilActive:
		Globals.selectedSubvoxel = self
		outlineMesh.visible = false
	pass
