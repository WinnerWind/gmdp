extends Node

var config_file:String = "res://templates/gummy/meta.ini"

var config := ConfigFile.new()
const SCENE_NAME_SECTION:String = "scenes"

func get_specific_page(page_number:int, custom_config_file:String = "res://templates/gummy/meta.ini") -> Slide:
	config.load(custom_config_file)
	if not MarkdownParser.data[0]: return
	
	var data := MarkdownParser.data
	var page = data[page_number]
	var page_to_load_path:String
	var content:String = page.content
	var heading:String = page.title
	var subheading:String = page.subtitle
	var images:Array = page.images
	var footer:String = page.footer
	
	match [!!heading, !!subheading, !!content, !!images, !!footer]:
		[true, false, true, false, false]: page_to_load_path = "heading_content"
		[true, true, true, false, false]: page_to_load_path = "heading_content_subtitle"
		[true, false, true, true, false]: page_to_load_path = iterate_scenes_and_send_warning("heading_%d_image", images.size())
		[true, false, false, false, false]: page_to_load_path = "title"
		[false, false, true, false, false]: page_to_load_path = "text_only"
		[false, false, false, true, false]: page_to_load_path = iterate_scenes_and_send_warning("gallery_%d_image", images.size())
		[true, false, true, false, true]: page_to_load_path = "heading_content_footer"
		_: page_to_load_path = "title"
	
	var page_to_load:PackedScene = load(get_canonical_path_from_config(page_to_load_path))
	var loaded_page:Slide = page_to_load.instantiate()
	loaded_page.set_content(heading, subheading, footer, content, images)
	return loaded_page

func get_canonical_path_from_config(key:String) -> String:
	if config.has_section_key(SCENE_NAME_SECTION, key):
		return config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, key)
	else:
		return config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, "text_only")

func iterate_scenes_and_send_warning(key:String, number:int) -> String:
	var original_number = number
	while PresentationParser.get_canonical_path_from_config(key % number) == "Does not exist!":
		number -= 1
	if original_number != number:
		push_warning("Scene {original_scene_name} was not found and it was substituted with {current_scene_name}".format({
			"original_scene_name": key % original_number,
			"current_scene_name": key % number
		}))
	return key % number
