extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/UserIDLabel.text = "User Id: " + str(multiplayer.get_unique_id())
	pass

@rpc("any_peer", "call_local")
func start_game():
	get_tree().change_scene_to_file("res://Levels/Tutorial/tutorial.tscn")

func _on_start_game_btn_pressed():
	print("start party")
	start_game.rpc()
	pass # Replace with function body.


func _on_start_game_btn_mouse_entered():
	$CanvasLayer/BtnSelectIndicator.visible = true
	$CanvasLayer/TooltipLabel.visible = true

func _on_start_game_btn_mouse_exited():
	$CanvasLayer/BtnSelectIndicator.visible = false
	$CanvasLayer/TooltipLabel.visible = false
