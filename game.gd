extends Node3D

@export var speed : float

var config 
var key : String
var system_prompt := 'Does the User\'s message fit into the category of %s. Answer only yes or no in lowercase, one word.'

# 1 to the left
#-1 to the right
var dir := 1 

var camera : Node
var ball : Node
var path : Node
var follow : Node
var http : HTTPRequest
var width
var state := {}

var roll := true
var prompts := ["Fruits", "Fruits"]#["The periodic table", "Fruits", "Vegetables", "Films", "England's cities"]

var STT : SpeechToText

func prompt():
	$Card/Text.text = prompts.pick_random()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config = ConfigFile.new()
	
	prompt()
	
	if speed == 0:
		speed = 0.3
	
	http = $HTTPRequest
	path = $Path
	follow = $Path/PathFollow3D
	width = DisplayServer.screen_get_size().x
	
	var err = config.load("user://config.ini")
	
	if err != OK:
		return
	
	key = config.get_value("Settings", 'groq_api', "null")
	AudioServer.input_device = config.get_value("Settings", "input_audio", "Default")
	
	#http.request(
		#"https://api.groq.com/openai/v1/chat/completions",
		#PackedStringArray(["Authorization: Bearer "+key,"Content-Type: application/json"]),
		#HTTPClient.Method.METHOD_POST,
		#'{"model": "llama-3.1-8b-instant","messages": [{"role": "user","content": "Placeholder Message"}]}'
	#)
	
	print(DirAccess.get_files_at("user://"))
	print(FileAccess.get_file_as_string("user://config.ini"))
	print("key %s" % key)

#func _input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
		#if event.pressed: # Down.
			#state[event.index] = event.position
		#else: # Up.
			#state.erase(event.index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow.progress_ratio >= 1:
		$GUI.LR.visible = true
		roll = false
	if follow.progress <= 0:
		$GUI.LS.visible = true
		roll = false
	#if len(state) > 0:
		#if state[0].x < width/2:
			#dir = -1
		#else:
			#dir = 1
	
	if roll:
		follow.progress += speed*delta*dir
		
	#speech to text
	update_text()


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(key)
	print(json)
	
	if  !json.keys().has("choices"):
		push_error("Unexpected: Groq Has No Answer Error")
		return
	
	var ans = 	json["choices"][0]["message"]["content"]
	print(ans)
	"sader"
	if ans.to_lower().begins_with("y"):
		dir *= -1
		print("\n\n\n-----CORRECT-----\n\n\n")


func _on_speech_to_text_transcribed_msg(is_partial: Variant, new_text: Variant) -> void:
	#if is_partial == false:
		#print("recog " + new_text +"\n")
		#print(key)
		#var a = '{"model": "llama-3.1-8b-instant","messages": [{"role":"system","content": "%s"},{"role": "user","content": "%s"}]}' % [system_prompt % [$Card/Text.text], str(new_text)]
		#print(a)
		#http.request(
			#"https://api.groq.com/openai/v1/chat/completions",
			#PackedStringArray(["Authorization: Bearer "+key,"Content-Type: application/json"]),
			#HTTPClient.Method.METHOD_POST, 
			#a
		#)
		#
	#else:
		#print("not yet\n")
	
	var ind = 0
	if dir == 1:
		ind+=1
	
	if is_partial == true:
		completed_text[ind] += new_text
		partial_text[ind] = ""
	else:
		if new_text!="":
			partial_text[ind] = new_text

func update_text():

	$GUI.set_panel_right("")
	$GUI.append_panel_right( completed_text[1] + "[color=green]" + partial_text[1] + "[/color]")

	$GUI.set_panel_left("")
	$GUI.append_panel_left( completed_text[0] + "[color=green]" + partial_text[0] + "[/color]")
	


var completed_text := ["",""]
var partial_text := ["",""]



func _on_gui_submit(ind = 0) -> void:
	#if (dir == 1 and !is_right) or (dir == -1 and is_right):

		### Doesn't receive text from speech
		print("\n-----")
		print(completed_text)
		print(partial_text)
		var a = '{"model": "llama-3.1-8b-instant","messages": [{"role":"system","content": "' +system_prompt % [$Card/Text.text]+ '"},{"role": "user","content": "' +completed_text[ind]+partial_text[ind]+'"}]}'
		print(a)
		print("\n\n\n")
		http.request(
			"https://api.groq.com/openai/v1/chat/completions",
			PackedStringArray(["Authorization: Bearer "+key,"Content-Type: application/json"]),
			HTTPClient.Method.METHOD_POST, 
			a
		)
		


func _on_gui_clear_left() -> void:
	completed_text[0] = ""
	partial_text[0] = ""


func _on_gui_clear_right() -> void:
	completed_text[1] = ""
	partial_text[1] = ""


func _on_gui_submit_left() -> void:
	_on_gui_submit(0) # Replace with function body.


func _on_gui_submit_right() -> void:
	_on_gui_submit(1)
