extends Spatial
class_name Interactable
# defines objects that can be interacted with such as workstations and inventories
# maybe abstract this later into a workstations and storage script



func _ready():
	add_to_group("Interactable")
	return

func _process(delta):
	return

func onActive():
	return

func onDeactive():
	return
