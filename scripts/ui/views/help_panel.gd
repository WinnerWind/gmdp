extends MarginContainer
class_name HelpPanel

@export var tree:Tree
@export var content_label:RichTextLabel
@export_dir var docs_path:String

func _ready() -> void:
	load_docs_in_dir(docs_path)


func load_docs_in_dir(directory_path:String = "") -> void:
	var dir_name := directory_path.trim_prefix(directory_path.get_base_dir()+"/")
	var parent_dir_name := directory_path.trim_suffix("/"+dir_name).trim_prefix(docs_path+"/")
	var dir = DirAccess.open(directory_path)
	set_tree_button(dir_name, parent_dir_name if not parent_dir_name == docs_path.trim_suffix("/"+dir_name) else "")
	for directory:String in dir.get_directories():
		load_docs_in_dir(directory_path +"/" + directory)

func load_index_file(path:String) -> void:
	var index_path := path + "/index.md"
	if FileAccess.file_exists(index_path):
		var file = FileAccess.open(index_path, FileAccess.READ)

func set_tree_button(child_name:String, parent_name:String = "") -> void:
	if parent_name == "": #looking for root
		var parent = tree.create_item()
		parent.set_text(0,child_name)
	else: #Has a parent
		# find parent item
		print(find_tree_item_by_text(tree.get_root(), parent_name).get_text(0))
		var parent = find_tree_item_by_text(tree.get_root(), parent_name)
		var child = tree.create_item(parent)
		child.set_text(0,child_name)

func find_tree_item_by_text(current_item: TreeItem, target_text: String, column_index: int = 0) -> TreeItem:
	if current_item == null:
		return null

	# Check the text of the current item in the specified column
	if current_item.get_text(column_index) == target_text:
		return current_item

	# Check children
	var child = current_item.get_first_child()
	while child != null:
		var found_item = find_tree_item_by_text(child, target_text, column_index)
		if found_item != null:
			return found_item
		child = child.get_next()

	return null
