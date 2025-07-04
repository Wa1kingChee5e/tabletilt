extends Control

var LS : Label
var LR : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LS = $LS
	LR = $LR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")  # Replace with function body.
