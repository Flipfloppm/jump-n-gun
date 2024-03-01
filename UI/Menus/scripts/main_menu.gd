extends Control
@onready var buttonContainer = $VBoxContainer
@onready var settings = $Settings
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.settingsExit.connect(exitSettings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_multiplayer_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menus/Server Connecting/username.tscn")

func _on_exit_btn_pressed():
	get_tree().quit()


func _on_settings_btn_pressed():
	buttonContainer.visible = false
	settings.visible = true

func exitSettings():
	settings.visible = false
	buttonContainer.visible = true
