extends Control

signal client_disconnect_request(player_id)

#@onready var player_list_container = $Panel/VBoxContainer/player_list
@onready var char_select_container = $Panel/HBoxContainer
@onready var select_world_btn = $VBoxContainer/SelectWorldBtn
@onready var exit_room_btn = $VBoxContainer/ExitRoomBtn
@onready var cancel_host_btn = $VBoxContainer/CancelHostBtn

@onready var tutorial_btn = $VBoxContainer/HBoxContainer/TutorialBtn
@onready var party_btn = $VBoxContainer/HBoxContainer/PartyBtn
@onready var coop_btn = $VBoxContainer/HBoxContainer/CoopBtn
@onready var gotogame_btn = $VBoxContainer/GoToGameBtn

#@export var charSelectScene: PackedScene
var charSelectScene = preload("res://UI/Menus/Server Connecting/Components/character_select.tscn")
var lobbySet = {}
var gameMode = -1

# sync go to game button
var hover_on_gotogame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_players(GameManager.PLAYERS)
	
	# syncing gotogame button hover. 
	if multiplayer.get_unique_id() == 1:
		hover_on_gotogame = gotogame_btn.is_hovered()
	else:
		$VBoxContainer/TooltipLabel.text = "Waiting for host to continue"
	if hover_on_gotogame:
		gotogame_btn.add_theme_color_override("font_color", Color(0,116,255,255))
	else:
		gotogame_btn.remove_theme_color_override("font_color")
	pass
	
	
func refresh_players(players):
	# Remove any player that are no longer in the room
	for character in char_select_container.get_children():
		if players.has(character.controllerId):
			continue
		else:
			# the player is no longer in the server, remove this player's element.
			character.queue_free()
			lobbySet.erase(character.controllerId)
	# Add any potential player
	for player_id in players:
		if lobbySet.has(player_id):
			continue
		var charSelect = charSelectScene.instantiate()
		charSelect.setup(players[player_id]["name"], player_id, multiplayer.get_unique_id(),
		players[player_id]["character"])
		char_select_container.add_child(charSelect)
		lobbySet[player_id] = 1


func _on_exit_room_btn_pressed():
	client_disconnect_request.emit(multiplayer.get_unique_id())

func set_visibility(role):
	if role == 1: # when its the host
		exit_room_btn.visible = false
	else:
		exit_room_btn.visible = true
		cancel_host_btn.visible = false
		# when not the host, the player can see the buttons, but not use them
		tutorial_btn.disabled = true
		party_btn.disabled = true
		coop_btn.disabled = true
		gotogame_btn.disabled = true

func show_popup(error):
	$PopupPanel/ErrorMsgLabel.text = error
	$PopupPanel.visible = true
	$PopupPanel/ErrorMsgLabel.visible = true


func _on_tutorial_btn_pressed():
	gameMode = 1
	tutorial_btn.button_pressed = true
	party_btn.button_pressed = false
	coop_btn.button_pressed = false


func _on_party_btn_pressed():
	gameMode = 2
	tutorial_btn.button_pressed = false
	party_btn.button_pressed = true
	coop_btn.button_pressed = false


func _on_coop_btn_pressed():
	gameMode = 3
	tutorial_btn.button_pressed = false
	party_btn.button_pressed = false
	coop_btn.button_pressed = true


