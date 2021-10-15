extends Spatial
class_name Subvoxel
# note: subvoxels should inherit their material from their parent voxel

onready var outlineMesh = $OutlineMesh
onready var collider = $SubvoxelMesh/SubvoxelHitbox/CollisionShape
onready var mat: SpatialMaterial = $SubvoxelMesh.get_surface_material(0)

var smithingGrid: SmithingGrid # the subvoxel's parent smithingGrid, inherited from parent voxel
var parentVoxel: Voxel
var gridPosition: Vector3

func _ready():
	add_to_group("Subvoxels")
	return


func toggleSubvoxelCollider() -> void:
	collider.disabled = !collider.disabled
	return


# note: these should only call when subvoxelMode is true and anvil is active
func _on_SubvoxelHitbox_mouse_entered():
	if Globals.subvoxelMode && Globals.isAnvilActive():
		Globals.selectedSubvoxel = self
		outlineMesh.visible = true
	return
func _on_SubvoxelHitbox_mouse_exited():
	if Globals.subvoxelMode && Globals.isAnvilActive():
		Globals.selectedSubvoxel = self
		outlineMesh.visible = false
	return
