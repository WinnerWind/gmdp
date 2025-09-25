extends Control
class_name Slide

@export var heading_label:RichTextLabel
@export var subheading_label:RichTextLabel
@export var contents_label:RichTextLabel
@export var footer_label:RichTextLabel
@export var image_nodes:Array[TextureRect]

@export var heading_format:String = "%s"
@export var subheading_format:String = "%s"
@export var content_format:String = "%s"
@export var footer_format:String = "%s"

func set_scale_no_size(new_scale:Vector2):
	var previous_size = size
	scale = new_scale
	set_deferred(&"size", previous_size / scale)

func set_content(heading:String, subheading:String, footer:String, content:String, images:Array):
	if heading_label: heading_label.text = heading_format % heading
	if subheading_label: subheading_label.text = subheading_format % subheading
	if contents_label: contents_label.text = content_format % content
	if footer_label: footer_label.text = footer_format % footer
	if image_nodes:
		for index in images.size():
			var image_node:TextureRect = image_nodes[index]
			if image_node:
				image_node.texture = MarkdownParser.get_image_from_name(images[index])
