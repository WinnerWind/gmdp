extends RichTextLabel
class_name RichTextLabelWithReplacements

@export var replacements:Dictionary[String, String]
@export var colors:Dictionary[String, String]

func set_text_with_replacements(content:String):
	for replacement_key in replacements.keys():
		var replacement = replacements[replacement_key]
		content = content.replace(replacement_key, replacement)
	content = content.format(colors)
	text = content
