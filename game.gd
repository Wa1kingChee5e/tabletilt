extends Node3D

@export var speed : float

var dir := 1 

var camera : Node
var ball : Node
var path : Node
var follow : Node
var width
var state := {}

var roll := true
var prompts := ["The periodic table", "Fruits", "Vegetables", "Fords", "Klashnikov's guns", "Films", "Youtubers", "England's cities"]

func prompt():
	$Card/Text.text = prompts.pick_random()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prompt()
	if speed == 0:
		speed = 0.3
	
	ball = $CSGSphere3D
	path = $Path
	follow = $Path/PathFollow3D
	width = DisplayServer.screen_get_size().x
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed: # Down.
			state[event.index] = event.position
		else: # Up.
			state.erase(event.index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow.progress_ratio >= 1:
		$GUI.LR.visible = true
		roll = false
	if follow.progress <= 0:
		$GUI.LS.visible = true
		roll = false
	if len(state) > 0:
		if state[0].x < width/2:
			dir = -1
		else:
			dir = 1
	
	if roll:
		follow.progress += speed*delta*dir
	
	
