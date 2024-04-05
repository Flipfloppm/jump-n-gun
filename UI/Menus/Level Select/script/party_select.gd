extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/UserIDLabel.text = "User Id: " + str(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() != 1:
		$CanvasLayer/StartGameBtn.disabled = true
		$CanvasLayer/TooltipLabel.visible = true
		$CanvasLayer/TooltipLabel.text= "Waiting for host to continue"

@rpc("any_peer", "call_local","reliable")
func start_game():
	get_tree().change_scene_to_file("res://Levels/Party Levels/multiplayer_level.tscn")

func _on_start_game_btn_pressed():
	print("start party")
	if multiplayer.get_unique_id() == 1:
		start_game.rpc()
	else:
		show_popup("Wait for host to continue!")

func _on_start_game_btn_mouse_entered():
	$CanvasLayer/BtnSelectIndicator.visible = true
	$CanvasLayer/TooltipLabel.visible = true

func _on_start_game_btn_mouse_exited():
	$CanvasLayer/BtnSelectIndicator.visible = false
	$CanvasLayer/TooltipLabel.visible = false

func show_popup(error):
	$CanvasLayer/PopupPanel/ErrorMsgLabel.text = error
	$CanvasLayer/PopupPanel.visible = true
	$CanvasLayer/PopupPanel/ErrorMsgLabel.visible = true
	
