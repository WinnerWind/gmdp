extends MarginContainer
class_name WarningsPanel

@export_multiline var warning_placeholder:String
@export_multiline var theme_warning_placeholder:String
@export var warning_label:RichTextLabel

func send_warning(content:String, page_number:int):
	show()
	warning_label.push_color(Color.YELLOW)
	warning_label.append_text("\n\n"+warning_placeholder.format({
		"warning": content,
		"page": page_number
	}))

func send_theme_warning(content:String, theme_path:String):
	show()
	warning_label.push_color(Color.RED)
	warning_label.append_text("\n\n"+theme_warning_placeholder.format({
		"warning":content,
		"path":theme_path
	}))

func reset_warnings() -> void:
	warning_label.text = ""
