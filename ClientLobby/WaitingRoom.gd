extends Control

signal client_disconnect_request(player_id)

@onready var player_list_container = $Panel/VBoxContainer/player_list
@onready var start_game_btn = $VBoxContainer/StartGameBtn
@onready var exit_room_btn = $VBoxContainer/ExitRoomBtn
@onready var cancel_host_btn = $VBoxContainer/CancelHostBtn

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in player_list_container.get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UserIDLabel.text = "User ID: " + str(multiplayer.get_unique_id())
	if multiplayer.get_unique_id() != 1:
		# if not the host, hide the start game button
		exit_room_btn.visible = true
		start_game_btn.visible = false
		cancel_host_btn.visible = false
	else: 
		exit_room_btn.visible = false
	refresh_players(GameManager.PLAYERS)
	pass

func refresh_players(players):
	for child in player_list_container.get_children():
		child.queue_free()
	for player_id in players:
		var player_name
		#print(player_id, players[player_id])
		if players[player_id]["name"] != "":
			player_name = players[player_id]["name"]
		else: 
			player_name = "new player"
		var player_row = Label.new()
		player_row.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		player_row.text = player_name
		player_list_container.add_child(player_row)
	#print("count", player_list_container.item_count)


func _on_exit_room_btn_pressed():
	client_disconnect_request.emit(multiplayer.get_unique_id())
	
