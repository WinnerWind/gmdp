extends Control
class_name PageSubViewPort

@export var subviewport:SubViewport
func _ready() -> void:
	await get_tree().process_frame
	if get_parent() is BoxContainer:
		custom_minimum_size.y = get_parent_control().size.y
	else:
		push_warning("Parent %s is not a BoxContainer, so the slide will not set it's size."%get_parent().name)

func add_page(node:Node) -> void:
	subviewport.add_child(node)

func get_subviewport_texture() -> ViewportTexture:
	return subviewport.get_texture()
