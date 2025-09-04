extends Control

@export var heading_label:RichTextLabel
@export var subheading_label:RichTextLabel
@export var contents_label:RichTextLabel
@export var image_nodes:Array[TextureRect]

func set_content(heading:String, subheading:String, content:String, images:Array):
	if heading_label: heading_label.text = heading
	if subheading_label: subheading_label.text = subheading
	if contents_label: contents_label.text = content
