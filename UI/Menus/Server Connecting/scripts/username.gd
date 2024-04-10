extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ChooseLevel"):
		GameManager.username = $CanvasLayer/TextEdit.text
		get_tree().change_scene_to_file("res://UI/Menus/Server Connecting/server_select.tscn")
		
	if Input.is_action_pressed("PauseMenu"):
		get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")


func _on_submit_pressed():
	GameManager.username = $CanvasLayer/TextEdit.text
	get_tree().change_scene_to_file("res://UI/Menus/Server Connecting/server_select.tscn")
