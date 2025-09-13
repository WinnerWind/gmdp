extends MarginContainer
class_name HelpPanel

@export var tree:Tree
@export var content_label:RichTextLabel
@export_dir var docs_path:String

func _ready() -> void:
	get_directories_recursive(docs_path)

func get_directories_recursive(path:String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		printerr("Could not open: ", path)
		return
	var subdirs := dir.get_directories()
	if subdirs.is_empty(): return
	for subdir in subdirs:
		var child_abs := path.rstrip("/") + "/" + subdir
		var parent_name := child_abs.get_base_dir().trim_prefix(docs_path).split("/")[-1]
		add_to_tree(subdir,parent_name)
		get_directories_recursive(child_abs)

func add_to_tree(child_name:String, parent_name:String = "") -> void:
	if parent_name == "": # root element
		var parent = tree.create_item()
		parent.set_text(0,child_name)
	else:
		var parent = find_tree_item_by_name(parent_name)
		var child = tree.create_item(parent)
		child.set_text(0, child_name)

func find_tree_item_by_name(child_name:String) -> TreeItem:
	var child = tree.get_root() #start from root
	while child.get_text(0) != child_name:
		child = child.get_next_in_tree()
	return child

func _on_tree_cell_selected() -> void:
	var item := tree.get_selected()
	var path:String
	while item != null: #Iterate over the tree and get path
		path = item.get_text(0)+"/"+path
		item = item.get_parent()
	path = docs_path +"/"+ path #get docs path bcak
	set_text_content(path)

func set_text_content(absolute_path:String) -> void:
	var file = FileAccess.open(absolute_path+"index.md", FileAccess.READ)
	if not file: return
	
	content_label.text = file.get_as_text()
