extends MarginContainer

@export var text_label:RichTextLabel
@export var timer:Timer
@export var time_to_display:float = 5.0

func send_toast(content:String):
	show()
	text_label.text = content
	timer.start(time_to_display)
