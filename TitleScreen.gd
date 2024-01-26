extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene_to_file("res://ClientLobby/lobby.tscn")

#func _on_button_pressed():
	#get_tree().change_scene("res://ClientLobby/lobby.tscn")
	#pass # Replace with function body.
