extends MarginContainer
class_name SlideButton

@export var page_number_container:RichTextLabel
@export var content_blurb_container:RichTextLabel

func set_content(page_number:int, total_pages:int, content_blurb:String):
	page_number_container.text = "Page {page_number} of {total_pages}".format({"page_number": page_number, "total_pages": total_pages})
	content_blurb_container.text = content_blurb
