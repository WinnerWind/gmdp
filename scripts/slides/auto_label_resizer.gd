class_name AutoSizeRichTextLabel
extends RichTextLabel

@export_group("Auto Font Size")

## Min text size to reach
@export_range(1, 512, 1.0)
var min_font_size: int = 8:
	get:
		return min_font_size
	set(value):
		min_font_size = value
		if min_font_size >= max_font_size:
			min_font_size = max_font_size - 1
			push_warning(
				"min_font_size {0} >= max_font_size {1}, fixed to {2}"
				.format([value, max_font_size, min_font_size])
			)

		notify_property_list_changed()
		resize_text()

## Max text size to reach
@export_range(1, 512, 1.0)
var max_font_size: int = 64:
	get:
		return max_font_size
	set(value):
		max_font_size = value
		if max_font_size <= min_font_size:
			max_font_size = min_font_size + 1
			push_warning(
				"max_font_size {0} <= min_font_size {1}, fixed to {2}"
				.format([value, min_font_size, max_font_size])
			)

		notify_property_list_changed()
		resize_text()

@export_group("Font Step Size")

## Needs 2 numbers to work / will be automatically prefered over "Auto-Size"[br]
## when 2 numbers or more are present.
@export
var step_sizes: Array[int] = []:
	get:
		return step_sizes
	set(value):
		step_sizes = value
		step_sizes.sort()
		
		notify_property_list_changed()
		resize_text()

var _processing_flag: bool = false


func _ready() -> void:
	# TODO: change defaults instead of hard-setting!

	if autowrap_mode == TextServer.AUTOWRAP_OFF:
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		push_warning("changed autowrap_mode to " + str(autowrap_mode))

	resized.connect(do_resize_text)
	do_resize_text()


func resize_text() -> void:
	if not needs_resize():
		return

	do_resize_text()


func do_resize_text() -> void:
	# Prevent draw call stack handler
	if _processing_flag:
		return 
	
	_processing_flag = true
	
	if fit_content:
		push_warning("Fit content can't be used (program freeze), setting it to false!")
		fit_content = false
	
	for target_font_size: int in get_iterator():
		set(&"theme_override_font_sizes/bold_italics_font_size", target_font_size)
		set(&"theme_override_font_sizes/italics_font_size", target_font_size)
		set(&"theme_override_font_sizes/mono_font_size", target_font_size)
		set(&"theme_override_font_sizes/normal_font_size", target_font_size)
		set(&"theme_override_font_sizes/bold_font_size", target_font_size)

		if not get_content_height() > get_rect().size.y:
			break
	
	_processing_flag = false


func get_iterator() -> Array:
	if len(step_sizes) >= 2:
		var clone: Array[int] = step_sizes.duplicate()
		clone.reverse()
		return clone
	
	if len(step_sizes) == 1:
		push_warning(name + " Step sizes needs at least 2 numbers to work")
	
	return range(max_font_size, min_font_size, -1)	


func needs_resize() -> bool:
	# TODO: does this need a line-calculated get_line_offset?
	return get_content_height() > get_rect().size.y
