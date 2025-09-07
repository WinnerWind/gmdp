extends MenuButton
class_name PopupMenuButton

signal index_pressed(index:int)
signal id_pressed(id:int)

func _ready() -> void:
	get_popup().index_pressed.connect(index_pressed.emit)
	get_popup().id_pressed.connect(id_pressed.emit)
