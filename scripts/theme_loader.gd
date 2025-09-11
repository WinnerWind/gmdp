extends Node

func _init() -> void:
	find_custom_themes()

func find_custom_themes() -> void:
	var base_path = OS.get_executable_path().get_base_dir()
	var themes_path:String = base_path + "/" + "themes"
	var dir = DirAccess.open(themes_path)
	if dir:
		for file in dir.get_files():
			if file.get_extension() == "pck":
				var success = ProjectSettings.load_resource_pack(themes_path+"/"+file)
				if not success: push_error("Could not load pack %s" % file)
				else: print("Successfully loaded %s!"% file)
