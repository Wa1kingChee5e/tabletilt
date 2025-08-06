extends Control

var config = ConfigFile.new()
var STT : SpeechToText
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var a = DirAccess.open("user://")
	#a.remove("user://config.ini")

		
	
	# Audio device list
	var input_audio_devices = AudioServer.get_input_device_list()
	for device in input_audio_devices:
		$Panel/ItemList.add_item(device)
	
		
	# Config Check
	if !FileAccess.file_exists("user://config.ini") or FileAccess.get_file_as_string("user://config.ini") == "":
		var file = FileAccess.open("user://config.ini", FileAccess.WRITE)
		file.store_line('[Settings]')
		file.store_line('groq_api="null"')
		file.store_line('input_audio="Default"')
		file.store_line('language="en"')
		file.close()
	
	# Config Load	
	var err = config.load("user://config.ini")
	
	if err != OK:
		return
	
	AudioServer.input_device = config.get_value("Settings", "input_audio", "Default")
	$Panel/ItemList.select(AudioServer.get_input_device_list().find(AudioServer.input_device))
	
	print(DirAccess.get_files_at("user://"))
	print("--")
	print(FileAccess.get_file_as_string("user://config.ini"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void: # game
	get_tree().change_scene_to_file("res://game.tscn") 


func _on_button_2_pressed() -> void: # translate
	var l = TranslationServer.get_locale()
	if l == "en":
		TranslationServer.set_locale("ru")
		$Button2.text = "Русский"
	else:
		TranslationServer.set_locale("en")
		$Button2.text = "English"


func _on_item_list_item_selected(index: int) -> void: 
	var a = AudioServer.get_input_device_list()
	print(a[index])
	AudioServer.input_device = a[index]
	config.set_value("Settings", "input_audio", a[index])
	config.save("user://config.ini")


func set_api_key():
	set_config("groq_api", $ApiPanel/Edit.text)

func _on_submit_pressed() -> void:
	set_api_key() # Replace with function body.


func _on_edit_text_submitted(new_text: String) -> void:
	set_api_key() # Replace with function body.

func set_config(key : String, value):
	
	var err = config.load("user://config.ini")
	
	if err != OK:
		return
	
	config.set_value("Settings", key, value)
	config.save("user://config.ini")


func _on_body_meta_clicked(meta: Variant) -> void:
	if meta == "groq.com":
		OS.shell_open("https://groq.com")
