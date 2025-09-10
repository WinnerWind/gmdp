extends MarginContainer
class_name WarningsPanel

@export_multiline var warning_placeholder:String
@export var warning_label:RichTextLabel

func send_warning(content:String, page_number:int):
	show()
	warning_label.push_color(Color.YELLOW)
	warning_label.append_text("\n\n"+warning_placeholder.format({
		"warning": content,
		"page": page_number
	}))
