extends Node
## This script parses markdown into data that the presentation devices can understand

var data:Array[Dictionary]
@export_file("*.md") var test_files:Array[String]

const PAGE_SPLITTER:String = "\n---\n\n"
#const HEADING_1_REGEX:String = r"^#\s.*"
const HEADING_1_REGEX:String = r"^# (.*)"

func _ready() -> void:
	parse_file_content(get_file_content(test_files[0]))

func get_file_content(file_path:String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	return file.get_as_text()

func parse_file_content(contents:String) -> void:
	# Split Pages
	var pages:PackedStringArray = contents.split(PAGE_SPLITTER)
	data.resize(pages.size())
	
	var heading_regex = RegEx.new()
	heading_regex.compile(HEADING_1_REGEX)
	
	for page_index in pages.size():
		var page = pages[page_index]
		data[page_index] = {
			"title": "",
			"content": ""
		}
		# headings
		var headings:Array[RegExMatch] = heading_regex.search_all(page)
		for heading:RegExMatch in headings: data[page_index]["title"] = heading.get_string().trim_prefix("# ")
	
	print(data)
