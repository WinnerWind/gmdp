extends Node
## This script parses markdown into data that the presentation devices can understand

var data:Array[Dictionary]

const PAGE_SPLITTER:String = "\n---\n"
const HEADING_1_REGEX:String = r"^# (.*)"
const HEADING_2_REGEX:String = r"^## (.*)"
const IMAGE_REGEX:String = r"\!\[.*\]\(.*\)"
const IMAGE_NAME_REGEX:String = r"\!\[.*\]"
const ITALIC_BOLD_REGEX:String = r"\*\*\*.*\*\*\*"
const BOLD_REGEX:String = r"\*\*.*\*\*"
const ITALIC_REGEX:String = r"\*.*\*"
const INLINE_CODE_REGEX:String = r"`.*`"
const MULTILINE_CODE_REGEX:String = r"```.*\n.*\n```"
const COMMENT_REGEX:String = r"(%%\n.*?\n%%)|(%%.*?%%)"
const BULLET_REGEX:String = r"(?<=\n)([-+*]\s.*\n{1,})+"

var last_file_path:String
var last_file_basepath:String:
	get:
		return last_file_path.get_base_dir()

func get_file_content(file_path:String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	last_file_path = file_path
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
		## markdown to bbcode
		# Bullet points
		var bullet_regex:RegEx = RegEx.new()
		bullet_regex.compile(BULLET_REGEX)
		var bullet_texts:Array[RegExMatch] = bullet_regex.search_all(page)
		for bullet in bullet_texts:
			page = page.replace(bullet.get_string(),"[ul]\n%s[/ul]" % bullet.get_string().replace("- ", "").replace("* ","").replace("+ ",""))
		
		
		# Comments
		var comment_regex:RegEx = RegEx.new()
		comment_regex.compile(COMMENT_REGEX)
		var comment_texts:Array[RegExMatch] = comment_regex.search_all(page)
		for comment in comment_texts:	page = page.replace(comment.get_string(), "")
		
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
		
		# code
		var multiline_code_regex := RegEx.new()
		multiline_code_regex.compile(MULTILINE_CODE_REGEX)
		var multiline_code_text:Array[RegExMatch] = multiline_code_regex.search_all(page)
		for code:RegExMatch in multiline_code_text:
			var code_bbcode:String = "[code]%s[/code]" % code.get_string().replace("```", "")
			page = page.replace(code.get_string(), code_bbcode)
		
		var code_text:Array[RegExMatch] = regex_every_line(page, INLINE_CODE_REGEX)
		for code:RegExMatch in code_text:
			var code_bbcode:String = "[code]%s[/code]" % code.get_string().replace("`", "")
			page = page.replace(code.get_string(), code_bbcode)
		
		
		# filter the content
		for heading in headings: page = page.replace(heading.get_string(), "")
		for subheading in subheadings: page = page.replace(subheading.get_string(), "")
		for image:RegExMatch in images: page = page.replace(image.get_string(), "")
		page = page.strip_edges()
		
		data[page_index]["content"] = page
		
	#print(data)

static func regex_every_line(content:String, search_regex:String) -> Array[RegExMatch]:
	var search = RegEx.new()
	search.compile(search_regex)
	var matches:Array[RegExMatch]
	for line in content.split("\n"):
		var match:Array[RegExMatch] = search.search_all(line)
		if match: #Found a regex match
			matches.append_array(match)
	return matches

func get_image_from_name(image_name:String) -> ImageTexture:
	var full_image_path = last_file_basepath + "/" + image_name
	if FileAccess.file_exists(full_image_path):
		var image = Image.new()
		var error = image.load(full_image_path)
		if error == OK:
			return ImageTexture.create_from_image(image)
		else:
			return
	else:
		return null
