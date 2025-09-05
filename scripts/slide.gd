extends Control

@export var heading_label:RichTextLabel
@export var subheading_label:RichTextLabel
@export var contents_label:RichTextLabel
@export var image_nodes:Array[TextureRect]

func set_scale_no_size(new_scale:Vector2):
	var previous_size = size
	scale = new_scale
	set_deferred(&"size", previous_size / scale)

func set_content(heading:String, subheading:String, content:String, images:Array):
	if heading_label: heading_label.text = heading
	if subheading_label: subheading_label.text = subheading
	if contents_label: contents_label.text = content
	if image_nodes:
		for index in image_nodes.size():
			var image_node:TextureRect = image_nodes[index]
			image_node.texture = MarkdownParser.get_image_from_name(images[index])
