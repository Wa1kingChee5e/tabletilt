extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
