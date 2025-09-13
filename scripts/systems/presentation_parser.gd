extends Node

signal send_warning(content:String, page_number:int)

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
		[true, true, true, true, false]: page_to_load_path = iterate_scenes_and_send_warning("heading_subtitle_content_%d_image", images.size(), page_number)
		[true, true, true, false, true]: page_to_load_path = "heading_subtitle_content_footer"
		[true, true, true, false, false]: page_to_load_path = "heading_subtitle_content"
		[true, true, false, true, false]: page_to_load_path = iterate_scenes_and_send_warning("heading_subtitle_%d_image", images.size(), page_number)
		[true, true, false, false, false]: page_to_load_path = "heading_subtitle"
		[true, false, true, true, false]: page_to_load_path = iterate_scenes_and_send_warning("heading_content_%d_image", images.size(), page_number)
		[true, false, true, false, true]: page_to_load_path = "heading_content_footer"
		[true, false, true, false, false]: page_to_load_path = "heading_content"
		[true, false, false, true, false]: page_to_load_path = iterate_scenes_and_send_warning("heading_%d_image", images.size(), page_number)
		[true, false, false, false, false]: page_to_load_path = "heading"
		[false, false, false, true, false]: page_to_load_path = iterate_scenes_and_send_warning("gallery_%d_image", images.size(), page_number)
		[false, false, true, false, false]: page_to_load_path = "content"
		[false, false, true, true, false]: page_to_load_path = iterate_scenes_and_send_warning("content_%d_image", images.size(), page_number)
		_: page_to_load_path = "content"
	
	var canonical_path = get_canonical_path_from_config(page_to_load_path, page_number)
	if not FileAccess.file_exists(canonical_path): canonical_path = get_canonical_path_from_config("content", page_number)
	var page_to_load:PackedScene = load(canonical_path)
	var loaded_page:Slide = page_to_load.instantiate()
	loaded_page.set_content(heading, subheading, footer, content, images)
	return loaded_page

func get_canonical_path_from_config(key:String, page_number:int, send_warnings:bool = true) -> String:
	if config.has_section_key(SCENE_NAME_SECTION, key):
		return config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, key)
	else:
		if send_warnings:
			var warning_text := "Your current theme does not have any styles for {original_style}. Using the \"text_only\" style instead.".format({
				"original_style": key
			})
			push_warning(warning_text)
			send_warning.emit(warning_text, page_number)
		return config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, "content")

func iterate_scenes_and_send_warning(key:String, number:int, page_index:int) -> String:
	var original_number = number
	# Ensure we aren't getting the text only scene back
	while get_canonical_path_from_config(key % number, page_index, false) == config_file.get_base_dir() + "/" + config.get_value(SCENE_NAME_SECTION, "content"):
		number -= 1
		if number <= 1: 
			number = 1
			break
	if original_number != number:
		var warning_text := "Scene {original_scene_name} was not found and it was substituted with {current_scene_name}".format({
			"original_scene_name": key % original_number,
			"current_scene_name": key % number
		})
		push_warning(warning_text)
		send_warning.emit(warning_text, page_index+1)
	return key % number
