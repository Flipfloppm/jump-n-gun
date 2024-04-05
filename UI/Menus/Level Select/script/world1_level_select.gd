extends Control

var selected_level = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/UserIDLabel.text = "User Id: " + str(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() != 1:
		$CanvasLayer/StartGameBtn.visible = false
		$CanvasLayer/TipLabel.text = "Wait for host to choose a level"
	
func _on_trash_btn_mouse_entered():
	$CanvasLayer/Background.frame = 1
	pass # Replace with function body.
func _on_computer_btn_mouse_entered():
	$CanvasLayer/Background.frame = 2
	pass # Replace with function body.
func _on_water_btn_mouse_entered():
	$CanvasLayer/Background.frame = 3
	pass # Replace with function body.
func _on_hustle_btn_mouse_entered():
	$CanvasLayer/Background.frame = 4
	pass # Replace with function body.
func _on_clock_btn_mouse_entered():
	$CanvasLayer/Background.frame = 5
	pass # Replace with function body.

func _on_hustle_btn_mouse_exited():
	$CanvasLayer/Background.frame = 0 if selected_level == -1 else selected_level
	pass # Replace with function body.
func _on_clock_btn_mouse_exited():
	$CanvasLayer/Background.frame = 0 if selected_level == -1 else selected_level
	pass # Replace with function body.
func _on_water_btn_mouse_exited():
	$CanvasLayer/Background.frame = 0 if selected_level == -1 else selected_level
	pass # Replace with function body.
func _on_trash_btn_mouse_exited():
	$CanvasLayer/Background.frame = 0 if selected_level == -1 else selected_level
	pass # Replace with function body.
func _on_computer_btn_mouse_exited():
	$CanvasLayer/Background.frame = 0 if selected_level == -1 else selected_level
	pass # Replace with function body.


func _on_start_game_btn_pressed():
	start_game.rpc()
	
@rpc("any_peer", "call_local","reliable")
func start_game():
	if selected_level == 1:
		get_tree().change_scene_to_file("res://Levels/world1_job1.tscn")
	elif selected_level == 2:
		get_tree().change_scene_to_file("res://Levels/world1_job1.tscn")
	elif selected_level == 3:
		get_tree().change_scene_to_file("res://Levels/world1_job2.tscn")
	elif selected_level == 4:
		get_tree().change_scene_to_file("res://Levels/world1_job1.tscn")
	elif selected_level == 5:
		get_tree().change_scene_to_file("res://Levels/world1_job1.tscn")
	else:
		show_popup("No valid level selected!")

func show_popup(error):
	$CanvasLayer/PopupPanel/ErrorMsgLabel.text = error
	$CanvasLayer/PopupPanel.visible = true
	$CanvasLayer/PopupPanel/ErrorMsgLabel.visible = true
	


func _on_trash_btn_pressed():
	$CanvasLayer/Background.frame = 1
	selected_level = 1

func _on_computer_btn_pressed():
	$CanvasLayer/Background.frame = 2
	selected_level = 2

func _on_water_btn_pressed():
	$CanvasLayer/Background.frame = 3
	selected_level = 3

func _on_hustle_btn_pressed():
	$CanvasLayer/Background.frame = 4
	selected_level = 4

func _on_clock_btn_pressed():
	$CanvasLayer/Background.frame = 5
	selected_level = 5

