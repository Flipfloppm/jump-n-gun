extends Control

@onready var server = $CenterContainer/VBoxContainer/Server
@onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameEdit
@onready var selected_IP = $CenterContainer/VBoxContainer/GridContainer/IPEdit
@onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortEdit
@onready var joinBtn = $CenterContainer/VBoxContainer/JoinBtn
@onready var hostBtn = $CenterContainer/VBoxContainer/Server/HostGame
@onready var playerName = $CenterContainer/VBoxContainer/GridContainer/NameEdit
@onready var server_browser = $ServerBrowser
@onready var waiting_room = $WaitingRoom


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	$ServerBrowser.childServerJoin.connect(join_server_by_ip)
	waiting_room.client_disconnect_request.connect(remove_client)
	
# this gets called only by clients 
func connected_to_server():
	print("connected to server")
	# call register info on the server first
	register_player_info.rpc_id(1, player_name.text, multiplayer.get_unique_id())

# this gets called only by clients 
func connection_failed():
	print("connection failed")

func _on_host_game_pressed():
	var host_info = server.start_server()
	selected_port.text = str(host_info[0])
	selected_IP.text = str(host_info[1])
	joinBtn.disabled = true
	hostBtn.disabled = true
	register_player_info(player_name.text, multiplayer.get_unique_id())
	print(GameManager.PLAYERS)
	$ServerBrowser.setup_server_broadcast(playerName.text + "'s server")
	# move to waiting room
	$ServerBrowser.visible = false
	$CenterContainer.visible = false
	waiting_room.visible = true
	
	
	
	
func _on_join_btn_pressed(): 
	print("join pressed")
	join_server_by_ip(selected_IP.text)
	joinBtn.disabled = true

func join_server_by_ip(ip):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, int(selected_port.text))
	multiplayer.set_multiplayer_peer(peer)
	# move to waiting room
	$ServerBrowser.visible = false
	$CenterContainer.visible = false
	waiting_room.visible = true

func _on_start_game_btn_pressed():
	get_tree().change_scene_to_file("res://Levels/level_selection/World_Select.tscn")
	 # everybody will be notified to call their own start_game method

@rpc("any_peer", "call_local")
func start_game():
	var start_scene = load("res://Levels/tutorial.tscn").instantiate()
	get_tree().root.add_child(start_scene)
	print("started game" + str(multiplayer.get_unique_id()))
	server_browser.cleanup_browser()
	self.hide()
	
@rpc("any_peer")
func register_player_info(player_name, id):
	if not GameManager.PLAYERS.has(id):
		GameManager.PLAYERS[id] = {
			"name":player_name,
			"id":id,
			"score": 0
		}
	# after the server received the connected player's info, the server broadcast
	# the info to the other players.
	if multiplayer.is_server():
		for playerID in GameManager.PLAYERS:
			register_player_info.rpc(GameManager.PLAYERS[playerID].name, playerID)

# handle the case where a client clicks on "exit room" to leave the current session
# this is only done by the host. 
@rpc("any_peer")
func remove_client(client_id):
	print("trying to remove client:", client_id, "this id:", multiplayer.get_unique_id())
	if !multiplayer.is_server():
		remove_client.rpc_id(1, client_id)
		# go back to lobby
		waiting_room.visible = false
		$ServerBrowser.visible = true
		$CenterContainer.visible = true
		
	if multiplayer.get_unique_id() == 1:
		# remove the client peer
		if server.server_peer != null:
			server.server_peer.disconnect_peer(client_id)
		# remove the client peer from the game manager/player data
		GameManager.PLAYERS.erase(client_id)
		print("client removed, current players:", GameManager.PLAYERS)
		
		


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Levels/level_selection/selection-screen.tscn")
