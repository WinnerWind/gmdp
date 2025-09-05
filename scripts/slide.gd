extends Control

@export var heading_label:RichTextLabel
@export var subheading_label:RichTextLabel
@export var contents_label:RichTextLabel
@export var image_nodes:Array[TextureRect]

func _ready() -> void:
	# Set the minimum size so that 
	# Each slide takes up the entire area.
	await get_tree().process_frame #Delay required for parent to get size.
	set_page_size()

func set_page_size():
	if get_parent() is BoxContainer:
		custom_minimum_size.y = get_parent_control().size.y
	else:
		push_warning("Parent %s is not a BoxContainer, so the slide will not set it's size."%get_parent().name)

func set_content(heading:String, subheading:String, content:String, images:Array):
	if heading_label: heading_label.text = heading
	if subheading_label: subheading_label.text = subheading
	if contents_label: contents_label.text = content
	if image_nodes:
		for index in image_nodes.size():
			var image_node:TextureRect = image_nodes[index]
			image_node.texture = MarkdownParser.get_image_from_name(images[index])
