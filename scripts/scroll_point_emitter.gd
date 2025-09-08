extends ScrollContainer
class_name ScrollPointEmitter

signal scroll_changed(new_value:float)
func _ready() -> void:
	get_v_scroll_bar().value_changed.connect(scroll_changed.emit)
