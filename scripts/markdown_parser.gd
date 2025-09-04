extends Node
## This script parses markdown into data that the presentation devices can understand

var data:Array[Dictionary]
@export_file("*.md") var test_files:Array[String]

const PAGE_SPLITTER:String = "\n---\n"
const HEADING_1_REGEX:String = r"^# (.*)"
const HEADING_2_REGEX:String = r"^## (.*)"

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
	
	var subtitle_regex = RegEx.new()
	subtitle_regex.compile(HEADING_2_REGEX)
	
	for page_index in pages.size():
		var page:String = pages[page_index]
		data[page_index] = {
			"title": "",
			"subtitle": "",
			"content": ""
		}
		# headings
		var headings:Array[RegExMatch] = regex_every_line(page, heading_regex)
		var subheadings:Array[RegExMatch] = regex_every_line(page, subtitle_regex)
		
		for heading:RegExMatch in headings: data[page_index]["title"] = heading.get_string().trim_prefix("# ")
		for subheading:RegExMatch in subheadings: data[page_index]["subtitle"] = subheading.get_string().trim_prefix("## ")
		
		# filter the content
		for heading in headings: page = page.replace(heading.get_string(), "")
		for subheading in subheadings: page = page.replace(subheading.get_string(), "")
		page = page.strip_edges()
		data[page_index]["content"] = page
	print(data)

static func regex_every_line(content:String, search_regex:RegEx) -> Array[RegExMatch]:
	var matches:Array[RegExMatch]
	for line in content.split("\n"):
		var match:RegExMatch = search_regex.search(line)
		if match: #Found a regex match
			matches.append(match)
	return matches
