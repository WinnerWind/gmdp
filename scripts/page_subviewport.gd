extends Control
class_name PageSubViewPort

@export var subviewport:SubViewport
@export var center_container:Container
@export var page_size:Vector2
func _ready() -> void:
	await get_tree().process_frame
	if get_parent() is BoxContainer:
		custom_minimum_size.y = get_parent_control().size.y
	elif get_parent() is GridContainer: #Grid containers are still fine.
		pass
	else:
		push_warning("Parent %s is not a BoxContainer, so the slide will not set it's size."%get_parent().name)

func add_page(node:Control) -> void:
	for child in center_container.get_children(): child.queue_free()
	center_container.add_child(node)
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	node.size_flags_vertical = Control.SIZE_EXPAND_FILL

func get_subviewport_texture() -> ViewportTexture:
	return subviewport.get_texture()
