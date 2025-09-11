extends Control
class_name PresenterView

@export var page_container:PageSubViewPort
@export_file("*.tscn") var main_scene:String #do NOT use a packed scene for this as this causes a circular reference

var theme_data_path:String = "res://templates/gummy/meta.ini"
var total_pages_index:int = MarkdownParser.data.size() - 1
var current_page:int = 0:
	set(new_var):
		current_page = clamp(new_var,0,total_pages_index)
		page_container.add_page(PresentationParser.get_specific_page(current_page, theme_data_path))

var previous_mode:Window.Mode

func _ready() -> void:
	page_container.add_page(PresentationParser.get_specific_page(0, theme_data_path))
	previous_mode = get_window().mode
	get_window().mode = Window.MODE_FULLSCREEN

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Next Page"):
		current_page += 1
	elif event.is_action_pressed("Previous Page"):
		current_page -= 1
	elif event.is_action_pressed("Exit Presentation"):
		get_tree().root.get_node("Main").show()
		get_window().mode = previous_mode
		queue_free()
