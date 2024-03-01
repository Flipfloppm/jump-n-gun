extends Control

var selected_world = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/UserIDLabel.text = "User Id: " + str(multiplayer.get_unique_id())
	if selected_world == 1:
		$CanvasLayer/World1Selector.visible = true
		$CanvasLayer/World2Selector.visible = false
		$CanvasLayer/World3Selector.visible = false
	elif selected_world == 2:
		$CanvasLayer/World1Selector.visible = false
		$CanvasLayer/World2Selector.visible = true
		$CanvasLayer/World3Selector.visible = false
	elif selected_world == 3:
		$CanvasLayer/World1Selector.visible = false
		$CanvasLayer/World2Selector.visible = false
		$CanvasLayer/World3Selector.visible = true
	else:
		$CanvasLayer/World1Selector.visible = false
		$CanvasLayer/World2Selector.visible = false
		$CanvasLayer/World3Selector.visible = false
	pass
	

func _on_world_1_btn_pressed():
	selected_world = 1
	pass # Replace with function body.


func _on_world_2_btn_pressed():
	selected_world =2
	pass # Replace with function body.


func _on_world_3_btn_pressed():
	selected_world = 3
	pass # Replace with function body.

@rpc("any_peer","call_local")
func go_to_level_select(selected_world):
	print("going to world")
	if selected_world == 1:
		get_tree().change_scene_to_file("res://UI/Menus/Level Select/world1_level_select.tscn")
	elif selected_world == 2:
		get_tree().change_scene_to_file("res://UI/Menus/Level Select/world1_level_select.tscn")
	elif selected_world == 3:
		get_tree().change_scene_to_file("res://UI/Menus/Level Select/world1_level_select.tscn")
	else:
		show_popup("No valid world selected!")

func show_popup(error):
	$CanvasLayer/PopupPanel/ErrorMsgLabel.text = error
	$CanvasLayer/PopupPanel.visible = true
	$CanvasLayer/PopupPanel/ErrorMsgLabel.visible = true
	

func _on_continue_btn_pressed():
	print("Continue pressed")
	go_to_level_select.rpc(selected_world)

