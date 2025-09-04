extends Node
## This script parses markdown into data that the presentation devices can understand

var data:Array[Dictionary]
@export_file("*.md") var test_files:Array[String]

const PAGE_SPLITTER:String = "\n---\n"
const HEADING_1_REGEX:String = r"^# (.*)"
const HEADING_2_REGEX:String = r"^## (.*)"
const IMAGE_REGEX:String = r"\!\[.*\]\(.*\)"
const IMAGE_NAME_REGEX:String = r"\!\[.*\]"
const ITALIC_BOLD_REGEX:String = r"\*\*\*.*\*\*\*"
const BOLD_REGEX:String = r"\*\*.*\*\*"
const ITALIC_REGEX:String = r"\*.*\*"

func _ready() -> void:
	parse_file_content(get_file_content(test_files[0]))

func get_file_content(file_path:String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	return file.get_as_text()

func parse_file_content(contents:String) -> void:
	# Split Pages
	var pages:PackedStringArray = contents.split(PAGE_SPLITTER)
	data.resize(pages.size())
	
	for page_index in pages.size():
		var page:String = pages[page_index]
		data[page_index] = {
			"title": "",
			"subtitle": "",
			"images": [],
			"content": ""
		}
		# headings 
		var headings:Array[RegExMatch] = regex_every_line(page, HEADING_1_REGEX)
		var subheadings:Array[RegExMatch] = regex_every_line(page, HEADING_2_REGEX)
		
		for heading:RegExMatch in headings: data[page_index]["title"] = heading.get_string().trim_prefix("# ")
		for subheading:RegExMatch in subheadings: data[page_index]["subtitle"] = subheading.get_string().trim_prefix("## ")
		
		# deal with images
		var images:Array[RegExMatch] = regex_every_line(page, IMAGE_REGEX)
		
		for image:RegExMatch in images: 
			var image_name:RegExMatch = regex_every_line(image.get_string(), IMAGE_NAME_REGEX)[0]
			# Extract only the image link from ![]() syntax
			var image_link = image.get_string().replace(image_name.get_string(),"").replace("(","").replace(")","")
			data[page_index]["images"].append(image_link)
		
		# markdown to bbcode
		# bold and italics
		var bold_and_italic_text:Array[RegExMatch] = regex_every_line(page, ITALIC_BOLD_REGEX)
		var bold_text:Array[RegExMatch] = regex_every_line(page, BOLD_REGEX)
		var italic_text:Array[RegExMatch] = regex_every_line(page, ITALIC_REGEX)
		
		for bold_and_italic:RegExMatch in bold_and_italic_text:
			var bold_and_italic_bbcode:String = "[b][i]%s[/i][/b]" % bold_and_italic.get_string().replace("***", "")
			page = page.replace(bold_and_italic.get_string(), bold_and_italic_bbcode)
		
		for bold:RegExMatch in bold_text:
			var bold_bbcode:String = "[b]%s[/b]" % bold.get_string().replace("**","")
			page = page.replace(bold.get_string(), bold_bbcode)
		
		for italic:RegExMatch in italic_text:
			var italic_bbcode:String = "[i]%s[/i]" % italic.get_string().replace("*", "")
			page = page.replace(italic.get_string(), italic_bbcode)
		# filter the content
		for heading in headings: page = page.replace(heading.get_string(), "")
		for subheading in subheadings: page = page.replace(subheading.get_string(), "")
		for image:RegExMatch in images: page = page.replace(image.get_string(), "")
		page = page.strip_edges()
		
		data[page_index]["content"] = page
	print(data)

static func regex_every_line(content:String, search_regex:String) -> Array[RegExMatch]:
	var search = RegEx.new()
	search.compile(search_regex)
	var matches:Array[RegExMatch]
	for line in content.split("\n"):
		var match:RegExMatch = search.search(line)
		if match: #Found a regex match
			matches.append(match)
	return matches
