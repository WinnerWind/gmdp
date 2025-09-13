extends MarginContainer
class_name WarningsPanel

@export_multiline var warning_placeholder:String
@export_multiline var theme_warning_placeholder:String
@export_multiline var notification_placeholder:String
@export_multiline var notification_file_placeholder:String
@export var warning_title:String
@export var notification_title:String
@export var header_label:RichTextLabel
@export var warning_label:RichTextLabel

func send_warning(content:String, page_number:int):
	show()
	header_label.text = warning_title
	warning_label.push_color(Color.YELLOW)
	warning_label.append_text("\n\n"+warning_placeholder.format({
		"warning": content,
		"page": page_number
	}))
	warning_label.pop()

func send_theme_warning(content:String, theme_path:String):
	show()
	header_label.text = warning_title
	warning_label.push_color(Color.RED)
	warning_label.append_text("\n\n"+theme_warning_placeholder.format({
		"warning":content,
		"path":theme_path
	}))
	warning_label.pop()

func send_notification(content:String) -> void:
	show()
	header_label.text = notification_title
	warning_label.append_text("\n\n" + notification_placeholder.format({
		"content" : content
	}))

func send_file_notification(content:String, path:String) -> void:
	show()
	header_label.text = notification_title
	warning_label.append_text("\n\n" + notification_file_placeholder.format({
		"content" : content,
		"path" : path
	}))

func reset_warnings() -> void:
	warning_label.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit Context"):
		hide()
		reset_warnings()
