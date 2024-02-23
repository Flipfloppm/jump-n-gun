extends Control

signal client_disconnect_request(player_id)

#@onready var player_list_container = $Panel/VBoxContainer/player_list
@onready var char_select_container = $Panel/HBoxContainer
@onready var select_world_btn = $VBoxContainer/SelectWorldBtn
@onready var exit_room_btn = $VBoxContainer/ExitRoomBtn
@onready var cancel_host_btn = $VBoxContainer/CancelHostBtn
#@export var charSelectScene: PackedScene
var charSelectScene = preload("res://UI/Menus/character_select.tscn")
var lobbySet = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# first we add the host
	var charScene = charSelectScene.instantiate()
	#charScene.setup("host", multiplayer.get_unique_id())
	#char_select_container.add_child(charScene)
	# if not the host, hide the start game button
	if multiplayer.get_unique_id() != 1:
		exit_room_btn.visible = true
		select_world_btn.visible = false
		cancel_host_btn.visible = false
	else: 
		exit_room_btn.visible = false
	#lobbySet[multiplayer.get_unique_id()] = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_players(GameManager.PLAYERS)

func refresh_players(players):
	for player_id in players:
		if lobbySet.has(player_id):
			continue
		var charSelect = charSelectScene.instantiate()
		charSelect.setup("franklin", player_id, multiplayer.get_unique_id())
		char_select_container.add_child(charSelect)
		lobbySet[player_id] = 1


func _on_exit_room_btn_pressed():
	client_disconnect_request.emit(multiplayer.get_unique_id())
	
