extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func winner(name):
	$VBoxContainer/Status.text = name + " won!"

func _on_menu_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menus/Server Connecting/server_select.tscn")
