extends VBoxContainer
class_name ThemeEntry

@export var name_label:Label
@export var author_label:Label

signal pressed
func set_details(theme_name:String, author:String):
	name_label.text = theme_name
	author_label.text = author

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pressed.emit()
