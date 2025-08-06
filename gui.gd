extends Control

signal clear_right()
signal clear_left()
signal submit_left()
signal submit_right()

var LS : Label
var LR : Label
var InputLeft : RichTextLabel
var InputRight : RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LS = $LS
	LR = $LR
	InputLeft = $HBoxContainer/Panel/VBoxContainer/Input
	InputRight = $HBoxContainer/Panel2/VBoxContainer/Input

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_panel_left(text : String):
	InputLeft.text = text
	
func set_panel_right(text : String):
	InputRight.text = text
	
func append_panel_left(text : String):
	InputLeft.append_text(text)
	
func append_panel_right(text : String):
	InputRight.append_text(text)

func left_input() -> String:
	return InputLeft.text
	
func right_input() -> String:
	return InputRight.text


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")  # Replace with function body.


func _on_clear_pressed() -> void:
	$HBoxContainer/Panel/VBoxContainer/Input.text = ""
	emit_signal("clear_left")
	print("Left Pane Cleared")


func _on_clear_pressed_right() -> void:
	$HBoxContainer/Panel2/VBoxContainer/Input.text = ""
	emit_signal("clear_right")
	print("Right Pane Cleared")
	

func _on_submit_pressed() -> void:
	emit_signal("submit_left")
	print("Left Submit")


func _on_submit_pressed_right() -> void:
	emit_signal("submit_right")
	print("Right Submit")
