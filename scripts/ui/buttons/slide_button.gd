extends MarginContainer
class_name SlideButton

@export var page_number_container:RichTextLabel
@export var content_blurb_container:Label
@export var preview_container:TextureRect
@export var toggle_panel:Panel
var is_hovering_over:bool

signal go_to_page(page_number:int)

func set_content(page_number:int, total_pages:int, content_blurb:String, preview:Texture):
	page_number_container.text = "Page {page_number} of {total_pages}".format({"page_number": page_number, "total_pages": total_pages})
	content_blurb_container.text = content_blurb
	if preview: preview_container.texture = preview

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			go_to_page.emit()

func toggle():
	toggle_panel.theme_type_variation = "PanelSlideToggled"

func untoggle():
	toggle_panel.theme_type_variation = "PanelSlideUntoggled"
