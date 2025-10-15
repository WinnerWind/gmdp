@tool
extends TextureRect
class_name TrainTexture

@export var color:Color:
	set(new_color):
		color = new_color
		if material is ShaderMaterial:
			material.set_shader_parameter(&"color", Vector3(color.r, color.g, color.b))
		call_deferred(&"update_shapes")

@export_range(0,1,0.1) var lighten_amount:float = 0.2:
	set(new):
		lighten_amount = new
		call_deferred(&"update_shapes")
@export_range(0,6) var number_of_shapes:int:
	set(new_num):
		number_of_shapes = new_num
		call_deferred(&"update_shapes")
@export var scale_modifier:float = 1:
	set(new):
		scale_modifier = new
		update_shapes()

func update_shapes():
	pivot_offset = size/2
	scale = Vector2.ONE * scale_modifier
	if grid.get_children(): for child in grid.get_children(): child.free()
	for shape in number_of_shapes:
			var rect := TextureRect.new()
			rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			rect.texture = shapes[randi_range(0,shapes.size()-1)] # get random texture
			rect.modulate = color.lightened(lighten_amount)
			
			rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
			grid.add_child(rect,true)
			rect.owner = self
	for rest in 6-number_of_shapes:
		var spacer := Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
		grid.add_child(spacer,true)
		spacer.owner = self

@export var grid:GridContainer
@export var shapes:Array[Texture2D]

func _ready() -> void:
	number_of_shapes = randi_range(0,6)
