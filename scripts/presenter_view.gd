extends Control
class_name PresenterView

@export var page_container:PageSubViewPort

var total_pages_index:int = MarkdownParser.data.size() - 1
var current_page:int = 0:
	set(new_var):
		current_page = clamp(new_var,0,total_pages_index)
		page_container.add_page(PresentationManager.get_specific_page(current_page))

func _ready() -> void:
	page_container.add_page(PresentationManager.get_specific_page(0))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Next Page"):
		current_page += 1
	elif event.is_action_pressed("Previous Page"):
		current_page -= 1
