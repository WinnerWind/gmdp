extends Slide

@export var grid_node:GridContainer
@export var grid_definitions:Array[int]
func set_content(heading:String, subheading:String, footer:String, content:String, images:Array):
	for image in images.size():
		var img = TextureRect.new()
		img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		img.size_flags_horizontal =Control.SIZE_EXPAND_FILL
		img.size_flags_vertical = Control.SIZE_EXPAND_FILL
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image_nodes.append(img)
		grid_node.add_child(img)
	grid_node.columns = grid_definitions[images.size()]
	super(heading,subheading,footer,content,images)
