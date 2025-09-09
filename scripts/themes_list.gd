extends PanelContainer
class_name ThemesList

@export_dir var themes_path:String

@export var theme_list:VBoxContainer
@export var theme_name_label:RichTextLabel
@export var theme_by_label:RichTextLabel
@export var title_page:PageSubViewPort
@export var heading_page:PageSubViewPort
@export var subtitle_page:PageSubViewPort
@export var text_only_page:PageSubViewPort
@export var selection_button:Button
@export var url_button:Button

@export var theme_entry:PackedScene
func _ready() -> void:
	var dir = DirAccess.open(themes_path)
	for directory in dir.get_directories():
		var full_path:String = themes_path+"/"+directory
		var meta_file_full_path:String = full_path + "/meta.ini"
		if FileAccess.file_exists(meta_file_full_path):
			var config = ConfigFile.new()
			config.load(meta_file_full_path)
			# Data validation
			if "metadata" in config.get_sections() and "scenes" in config.get_sections():
				var scenes = config.get_section_keys("scenes")
				if "title" in scenes and "heading" in scenes and "heading_subtitle" in scenes and "text_only" in scenes:
					var metadata = config.get_section_keys("metadata")
					if "name" in metadata and "author" in metadata and "designed_by" in metadata and "version" in metadata and "date" in metadata and "url" in metadata:
						# All data checks are done so lets populate the scene
						var theme_name = config.get_value("metadata", "name")
						var author = config.get_value("metadata", "author")
						var designed_by = config.get_value("metadata", "designed_by")
						var version = config.get_value("metadata", "version")
						var date = config.get_value("metadata", "date")
						var url = config.get_value("metadata", "url")
						var heading_scene_path = meta_file_full_path.get_base_dir() + "/"+config.get_value("scenes", "heading")
						var title_scene_path = meta_file_full_path.get_base_dir() + "/"+config.get_value("scenes", "title")
						var heading_subtitle_scene_path = meta_file_full_path.get_base_dir() + "/"+config.get_value("scenes", "heading_subtitle")
						var text_only_scene_path = meta_file_full_path.get_base_dir() + "/"+config.get_value("scenes", "text_only")
						
						var new_theme_entry:ThemeEntry = theme_entry.instantiate()
						new_theme_entry.set_details(theme_name, author)
						new_theme_entry.pressed.connect(set_details.bind(theme_name, author, designed_by, version, date, url, heading_scene_path, title_scene_path, heading_subtitle_scene_path, meta_file_full_path, text_only_scene_path))
						theme_list.add_child(new_theme_entry)
					else:
						push_error("Metadata incomplete in %s" % meta_file_full_path)
				else: 
					push_error("Either title, heading, or heading_subtitle was not found in %s" % meta_file_full_path)
			else:
				push_error("Metadata file %s is missing a section (Found sections %s)"%[meta_file_full_path, config.get_sections()])

func set_details(theme_name:String, author:String, designed_by:String, version:String, date:String, url:String, heading_scene_path:String, title_scene_path:String, heading_subtitle_scene_path:String, meta_file:String, text_only_scene_path:String):
	theme_name_label.text = theme_name
	theme_by_label.text = "Authored by [b]{author}[/b] and designed by [b]{designer}[/b] on {date}. [i]Version v{version}[/i]".format({
		"author": author,
		"designer": designed_by,
		"version": version,
		"date": date
	})
	var heading_scene:Slide = load(heading_scene_path).instantiate()
	var title_scene:Slide = load(title_scene_path).instantiate()
	var subtitle_scene:Slide = load(heading_subtitle_scene_path).instantiate()
	var text_only_scene:Slide = load(text_only_scene_path).instantiate()
	
	heading_scene.call_deferred(&"set_scale_no_size", (Vector2.ONE * 3))
	title_scene.call_deferred(&"set_scale_no_size", (Vector2.ONE * 3))
	subtitle_scene.call_deferred(&"set_scale_no_size", (Vector2.ONE * 3))
	text_only_scene.call_deferred(&"set_scale_no_size", (Vector2.ONE * 3))
	
	title_scene.set_content(theme_name, "", "", [])
	heading_scene.set_content("So what is {theme_name}?".format({"theme_name":theme_name}), "", "This is a really beautiful theme made for GMDP!\nTry me out! Please!",[])
	subtitle_scene.set_content("So, you decided to try it", "but have you really?", "I mean, who's to say? Click the \"Use this theme\" button to try me!", [])
	text_only_scene.set_content("","","This is a scene which only has text. This scene contains nothing but text. What did you expect?", [])
	
	title_page.show()
	heading_page.show()
	subtitle_page.show()
	text_only_page.show()
	
	title_page.add_page(title_scene)
	heading_page.add_page(heading_scene)
	subtitle_page.add_page(subtitle_scene)
	text_only_page.add_page(text_only_scene)
	
	current_url = url
	current_theme_meta_file = meta_file
	
	url_button.show()
	selection_button.show()

var current_url:String = ""
func open_url():
	if not current_url == "":
		OS.shell_open(current_url)

func open_url_custom(custom_url:String):
	OS.shell_open(custom_url)

var current_theme_meta_file:String
signal switch_theme_to(theme_meta_file:String)
func use_theme():
	if not current_theme_meta_file == "":
		switch_theme_to.emit(current_theme_meta_file)
