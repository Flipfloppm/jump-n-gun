extends Control

signal client_disconnect_request(player_id)

@onready var char_select_container = $Panel/HBoxContainer
@onready var select_world_btn = $VBoxContainer/SelectWorldBtn
@onready var exit_room_btn = $VBoxContainer/ExitRoomBtn
@onready var cancel_host_btn = $VBoxContainer/CancelHostBtn
@export var charSelectScene :PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#for child in char_select_container.get_children():
		#child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UserIDLabel.text = "User ID: " + str(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() != 1:
		# if not the host, hide the start game button
		exit_room_btn.visible = true
		select_world_btn.visible = false
		cancel_host_btn.visible = false
	else: 
		exit_room_btn.visible = false
	#refresh_players(GameManager.PLAYERS)
	pass
#
#func refresh_players(players):
	#for child in char_select_container.get_children():
		##child.queue_free()
	#for player_id in players:
		#var player_name
		##print(player_id, players[player_id])
		#if players[player_id]["name"] != "":
			#player_name = players[player_id]["name"]
		#else: 
			#player_name = "new player"
		#var charSelect = charSelectScene.instantiate()
		##charSelect.UserId.text = player_name
		##player_row.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		##player_row.text = player_name
		#char_select_container.add_child(charSelect)
	#print("count", player_list_container.item_count)


func _on_exit_room_btn_pressed():
	client_disconnect_request.emit(multiplayer.get_unique_id())
	
