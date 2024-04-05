extends Control

@onready var worlds: Array = [$WorldIcon, $WorldIcon2, $WorldIcon3, $WorldIcon4, $WorldIcon5]
var current_world: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$playerIcon.global_position = worlds[current_world].global_position

func _process(delts):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("ui_left") and current_world > 0:
		current_world -= 1
		$playerIcon.global_position = worlds[current_world].global_position
		
	if event.is_action_pressed("ui_right") and current_world < worlds.size() - 1:
		current_world += 1
		$playerIcon.global_position = worlds[current_world].global_position

	if event.is_action_pressed("ChooseLevel"):
		start_game.rpc()
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://UI/Menus/Server Connecting/server_select.tscn")

@rpc("any_peer", "call_local","reliable")
func start_game():
	get_tree().change_scene_to_file("res://Levels/Tutorial/tutorial.tscn")
