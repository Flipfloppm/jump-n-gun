extends Control

@onready var server = $CanvasLayer/Server
@onready var hostBtn = $CanvasLayer/Server/HostGame
@onready var server_browser = $CanvasLayer/ServerBrowser
@onready var waiting_room = $CanvasLayer/WaitingRoom


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	server_browser.childServerJoin.connect(join_server_by_ip)
	waiting_room.client_disconnect_request.connect(remove_client)
	SignalBus.server_closed.connect(_on_server_closed)
	
# this gets called only by clients 
func connected_to_server():
	print("connected to server")
	# call register info on the server first
	#register_player_info.rpc_id(1, player_name.text, multiplayer.get_unique_id())
	register_player_info.rpc_id(1, "david", multiplayer.get_unique_id())

# this gets called only by clients 
func connection_failed():
	print("connection failed")

func _on_host_game_pressed():
	print("host game pressed")
	var host_info = server.start_server()
	hostBtn.disabled = true
	hostBtn.visible = false
	register_player_info("david", multiplayer.get_unique_id())
	print(GameManager.PLAYERS)
	#$ServerBrowser.setup_server_broadcast(playerName.text + "'s server")
	server_browser.setup_server_broadcast("david")
	# move to waiting room
	server_browser.visible = false
	waiting_room.visible = true
	$CanvasLayer/BackBtn.visible = false
	$CanvasLayer/Servers.visible = false

func join_server_by_ip(ip):
	var peer = ENetMultiplayerPeer.new()
	#peer.create_client(ip, int(selected_port.text))
	peer.create_client(ip, 3296)
	multiplayer.set_multiplayer_peer(peer)
	# move to waiting room
	server_browser.visible = false
	server.visible = false
	$CanvasLayer/BackBtn.visible = false
	$CanvasLayer/Servers.visible = false
	waiting_room.visible = true

func _on_start_game_btn_pressed():
	start_game.rpc()
	 # everybody will be notified to call their own start_game method

@rpc("any_peer", "call_local")
func start_game():
	var start_scene = load("res://Levels/tutorial.tscn").instantiate()
	get_tree().root.add_child(start_scene)
	print("started game" + str(multiplayer.get_unique_id()))
	server_browser.cleanup_browser()
	$CanvasLayer.visible = false
	self.hide()
	
@rpc("any_peer")
func register_player_info(player_name, id):
	if not GameManager.PLAYERS.has(id):
		GameManager.PLAYERS[id] = {
			"name":player_name,
			"id":id,
			"score": 0,
			"character": "guy"
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
		GameManager.PLAYERS.erase(client_id)
		# go back to lobby
		server_browser.visible = true
		server.visible = true
		$CanvasLayer/BackBtn.visible = true
		$CanvasLayer/Servers.visible = true
		waiting_room.visible = false
		
	if multiplayer.get_unique_id() == 1:
		# remove the client peer
		if server.server_peer != null:
			server.server_peer.disconnect_peer(client_id)
		# remove the client peer from the game manager/player data
		GameManager.PLAYERS.erase(client_id)
		print("client removed, current players:", GameManager.PLAYERS)


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Levels/level_selection/selection-screen.tscn")


func _on_select_world_btn_pressed():
	# when the host click on select world, every player should load that scene. 
	load_select_world_scene.rpc()
	
@rpc("any_peer","call_local")
func load_select_world_scene():
	print("going to select world tscn" + str(multiplayer.get_unique_id()))
	server_browser.cleanup_browser()
	get_tree().change_scene_to_file("res://Levels/level_selection/World_Select.tscn")


func _on_cancel_host_btn_pressed():
	SignalBus.broadcast_server_closed.rpc()
	
	
func _on_server_closed():
	print("server closed, handling")
	get_tree().reload_current_scene()
	GameManager.PLAYERS.clear()
	pass
	
	
	
