extends Control
class_name PresentationManager

@export_category("Nodes")
@export var main_slide_sorter:VBoxContainer
@export var main_slide_scroll:ScrollContainer
@export var slide_buttons_sorter:VBoxContainer
@export var text_editor:TextEdit
@export var editor_panel:PanelContainer
@export var themes_view:Control
@export var slides_view:Control
@export var location_label:RichTextLabel
@export var view_button:MenuButton
@export var warning_panel:WarningsPanel
@export_subgroup("FileDialogs")
@export var open_file:FileDialog
@export var save_file:FileDialog

@export_category("PackedScenes")
@export var slide_button_scene:PackedScene
@export var page_subviewport:PackedScene
@export_subgroup("Presentation")
@export var presentation:PackedScene


var total_pages:int

func switch_theme_to(theme_path:String):
	PresentationParser.config_file = theme_path
	refresh()

func _ready() -> void:
	get_window().size_changed.connect(iterate_pages)
	PresentationParser.send_warning.connect(warning_panel.send_warning)

func refresh() -> void:
	iterate_pages()
	var has_data = !MarkdownParser.data[0]
	view_button.get_popup().set_item_disabled(0, has_data)

func set_text_content() -> void:
	var text = text_editor.text
	MarkdownParser.refresh_set_content(text)
	
func iterate_pages():
	for child in main_slide_sorter.get_children(): child.free()
	if not MarkdownParser.data[0]: return #ensures we dont iterate over empty data
	
	var data:Array[Dictionary] = MarkdownParser.data
	
	for page_index in data.size():
		var page_subviewport_instance:PageSubViewPort = page_subviewport.instantiate()
		page_subviewport_instance.add_page(PresentationParser.get_specific_page(page_index, PresentationParser.config_file))
		main_slide_sorter.add_child(page_subviewport_instance)
	
	set_slide_buttons(data)


func set_slide_buttons(pages:Array):
	for child in slide_buttons_sorter.get_children(): child.queue_free()
	for index in pages.size():
		var page = pages[index]
		await get_tree().process_frame # Required to get subviewport texture
		var page_preview = main_slide_sorter.get_child(index).get_subviewport_texture() if main_slide_sorter.get_child(index).get_subviewport_texture() else null
		var slide_button:SlideButton = slide_button_scene.instantiate()
		slide_button.set_content(index+1, pages.size(), (page.content.replace("\n"," ") if page.content else page.title), page_preview if page_preview else null)
		slide_button.go_to_page.connect(scroll_to_page.bind(index))
		slide_buttons_sorter.add_child(slide_button)

func scroll_to_page(page_number:int):
	var scroll_max = main_slide_scroll.get_v_scroll_bar().max_value
	main_slide_scroll.scroll_vertical = int((float(scroll_max) / float(total_pages))*float(page_number))

func _on_tabs_tab_changed(tab: int) -> void:
	match tab:
		0: # slides
			slides_view.show()
			editor_panel.hide()
			themes_view.hide()
			await get_tree().process_frame #viewports need to come back up
			refresh()
		1: #text editor
			slides_view.hide()
			editor_panel.show()
			themes_view.hide() 
		2: # themes
			slides_view.hide()
			editor_panel.hide()
			themes_view.show()

func set_file_path(file_path:String):
	# Used when file is opened
	MarkdownParser.parse_file_content(MarkdownParser.get_file_content(file_path))
	text_editor.text = MarkdownParser.text_content
	location_label.text = "%s/[b]%s"%[MarkdownParser.last_file_basepath, MarkdownParser.last_file_path.get_file()]
	refresh()

func save(path:String):
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(MarkdownParser.text_content)
	file.close()
	MarkdownParser.last_file_path = path
	location_label.text = "%s/[b]%s"%[MarkdownParser.last_file_basepath, MarkdownParser.last_file_path.get_file()]
	print("Saved!")

func file_menu_functions(id:int):
	match id:
		0: #open file
			open_file.show()
		1: #save
			if MarkdownParser.last_file_path:
				save(MarkdownParser.last_file_path)
			else:
				save_file.show()
		2: #open new file
			MarkdownParser.last_file_path = ""
			MarkdownParser.text_content = ""
			MarkdownParser.parse_file_content(MarkdownParser.text_content)
			text_editor.text = MarkdownParser.text_content
			refresh()
		3: #exit
			get_tree().quit()

func view_menu_functions(id:int):
	match id:
		0: #start presentation
			var new_presentation:PresenterView = presentation.instantiate()
			new_presentation.theme_data_path = PresentationParser.config_file
			get_tree().root.add_child(new_presentation)
			hide()

func _on_main_scroll_changed(new_value: float) -> void:
	var new_value_int = int(new_value)
	# Essentially get the size of the viewport used.
	var page_height:int = int(main_slide_sorter.get_child(0).get_child(0).size.y)
	var current_page_number = snappedi(float(new_value_int)/float(page_height), 1) + 1
	
	for child:SlideButton in slide_buttons_sorter.get_children():
		child.untoggle()
	slide_buttons_sorter.get_child(current_page_number - 1).toggle()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Save"):
		if MarkdownParser.last_file_path:
			save(MarkdownParser.last_file_path)
		else:
			save_file.show()
	elif event.is_action_pressed("Open File"):
		open_file.show()
