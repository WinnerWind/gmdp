extends Node
class_name FileAccessWeb

signal data_loaded(text:String)

var _on_data_loaded_callback = null

func _ready() -> void:
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("loadData()")
		_on_data_loaded_callback = JavaScriptBridge.create_callback(_on_data_loaded)
		
		# Retrieve the 'gd_callbacks' object
		var gdcallbacks: JavaScriptObject = JavaScriptBridge.get_interface("gd_callbacks")
		
		# Assign the callbacks
		gdcallbacks.dataLoaded = _on_data_loaded_callback

func _on_data_loaded(data: Array):
	if not data.size() == 0:
		data_loaded.emit(data)
	queue_free()
