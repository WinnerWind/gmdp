extends Control
class_name PresentationManager

@export_file("*.ini") var config_file:String

@export_category("Nodes")
@export var main_slide_sorter:VBoxContainer
@export var main_slide_scroll:ScrollContainer
@export var slide_buttons_sorter:VBoxContainer
@export var text_editor:TextEdit
@export var themes_view:Control
@export var slides_view:Control

@export_category("PackedScenes")
@export var slide_button_scene:PackedScene
@export var page_subviewport:PackedScene

var config := ConfigFile.new()
const SCENE_NAME_SECTION:String = "scenes"

var total_pages:int

func switch_theme_to(theme_path:String):
	config_file = theme_path
	refresh()

func _ready() -> void:
	text_editor.text = MarkdownParser.text_content
	
	iterate_pages()
	get_window().size_changed.connect(iterate_pages)

func refresh() -> void:
	iterate_pages()

func set_text_content() -> void:
	var text = text_editor.text
	MarkdownParser.refresh_set_content(text)
	refresh()
	
func iterate_pages():
	for child in main_slide_sorter.get_children(): child.free()
	config.load(config_file)
	
	var page_to_load_path:String
	
	var data:Array[Dictionary] = MarkdownParser.data
	total_pages = data.size()
	
	for page in data:
		var content:String = page.content
		var heading:String = page.title
		var subheading:String = page.subtitle
		var images:Array = page.images
		
		match [!!heading, !!subheading, !!content, !!images]:
			[true, false, true, false]: page_to_load_path = "heading"
			[true, true, true, false]: page_to_load_path = "heading_subtitle"
			[true, false, true, true]: page_to_load_path = iterate_scenes_and_send_warning("heading_%d_image", images.size())
			[true, false, false, false]: page_to_load_path = "title"
			_: page_to_load_path = "title"
		
		var page_to_load:PackedScene = load(get_canonical_path_from_config(page_to_load_path))
		var loaded_page := page_to_load.instantiate()
		var subviewport:PageSubViewPort = page_subviewport.instantiate()
		subviewport.add_page(loaded_page)
		main_slide_sorter.add_child(subviewport)
		loaded_page.set_content(heading, subheading, content, images)
	
	set_slide_buttons(data)

func get_canonical_path_from_config(key:String) -> String:
	if config.has_section_key(SCENE_NAME_SECTION, key):
		return config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, key)
	else:
		return "Does not exist!"

func set_slide_buttons(pages:Array):
	for child in slide_buttons_sorter.get_children(): child.queue_free()
	for index in pages.size():
		var page = pages[index]
		var page_preview = main_slide_sorter.get_child(index).get_subviewport_texture()
		var slide_button:SlideButton = slide_button_scene.instantiate()
		slide_button.set_content(index+1, pages.size(), (page.content.replace("\n"," ") if page.content else page.title), page_preview)
		slide_button.go_to_page.connect(scroll_to_page.bind(index))
		slide_buttons_sorter.add_child(slide_button)

func iterate_scenes_and_send_warning(key:String, number:int) -> String:
	var original_number = number
	while get_canonical_path_from_config(key % number) == "Does not exist!":
		number -= 1
	if original_number != number:
		push_warning("Scene {original_scene_name} was not found and it was substituted with {current_scene_name}".format({
			"original_scene_name": key % original_number,
			"current_scene_name": key % number
		}))
	return key % number

func scroll_to_page(page_number:int):
	var scroll_max = main_slide_scroll.get_v_scroll_bar().max_value
	main_slide_scroll.scroll_vertical = int((float(scroll_max) / float(total_pages))*float(page_number))

func _on_tabs_tab_changed(tab: int) -> void:
	match tab:
		0: # slides
			slides_view.show()
			text_editor.hide()
			themes_view.hide()
			await get_tree().process_frame #viewports need to come back up
			refresh()
		1: #text editor
			slides_view.hide()
			text_editor.show()
			themes_view.hide() 
		2: # themes
			slides_view.hide()
			text_editor.hide()
			themes_view.show()

func set_file_path(file_path:String):
	MarkdownParser.parse_file_content(MarkdownParser.get_file_content(file_path))
	text_editor.text = MarkdownParser.text_content
	refresh()
