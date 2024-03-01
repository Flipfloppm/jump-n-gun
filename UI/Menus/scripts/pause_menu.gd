extends Control

func _ready():
	SignalBus.settingsExit.connect(exitSettings)
	

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_settings_btn_pressed():
	$VBoxContainer.visible = false
	$Settings.visible = true

func _on_resume_btn_pressed():
	set_paused(false)

var _is_paused:bool = false:
	set = set_paused

func _unhandled_input(event) -> void:
	if event.is_action_pressed("PauseMenu"):
		_is_paused = !_is_paused
		set_paused.rpc(_is_paused)
	
@rpc("any_peer","call_local")
func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused


func _on_menu_btn_pressed():
	set_paused(false)
	get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")


func _on_restart_btn_pressed():
	restart_game.rpc()
	
@rpc("any_peer", "call_local")
func restart_game():
	set_paused(false)
	get_tree().reload_current_scene()

func exitSettings():
	$Settings.visible = false
	$VBoxContainer.visible = true
