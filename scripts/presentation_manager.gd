extends Control
class_name PresentationManager

@export_file("*.md") var test_file:String
@export_file("*.ini") var config_file:String

@export var main_slide_sorter:VBoxContainer
@export var main_slide_scroll:ScrollContainer
@export var slide_buttons_sorter:VBoxContainer

@export var slide_button_scene:PackedScene

var config := ConfigFile.new()
const SCENE_NAME_SECTION:String = "scenes"

var total_pages:int
func _ready() -> void:
	MarkdownParser.parse_file_content(MarkdownParser.get_file_content(test_file))
	iterate_pages()
	get_window().size_changed.connect(iterate_pages)

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
			[true, false, true, true]: page_to_load_path = "heading_%d_image" % images.size()
			[true, false, false, false]: page_to_load_path = "title"
		
		var page_to_load:PackedScene = load(get_canonical_path_from_config(page_to_load_path))
		var loaded_page := page_to_load.instantiate()
		main_slide_sorter.add_child(loaded_page)
		loaded_page.set_content(heading, subheading, content, images)
	
	set_slide_buttons(data)
func get_canonical_path_from_config(key:String) -> String:
	return config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, key)

func set_slide_buttons(pages:Array):
	for child in slide_buttons_sorter.get_children(): child.queue_free()
	for index in pages.size():
		var page = pages[index]
		var slide_button:SlideButton = slide_button_scene.instantiate()
		slide_button.set_content(index+1, pages.size(), (page.content.replace("\n"," ") if page.content else page.title))
		slide_button.go_to_page.connect(scroll_to_page.bind(index))
		slide_buttons_sorter.add_child(slide_button)
func scroll_to_page(page_number:int):
	var max = main_slide_scroll.get_v_scroll_bar().max_value
	main_slide_scroll.scroll_vertical = (max / total_pages)*page_number
