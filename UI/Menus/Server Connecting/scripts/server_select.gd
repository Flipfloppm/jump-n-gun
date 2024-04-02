extends Control

@onready var hostBtn = $CanvasLayer/HostGame
@onready var server_browser = $CanvasLayer/ServerBrowser
@onready var waiting_room = $CanvasLayer/WaitingRoom
var server = Server


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(_on_disconnect_from_server)
	#server_browser.childServerJoin.connect(join_server_by_ip) # deprecated
	SignalBus.serverBrowserJoin.connect(join_server_by_ip) # new method
	waiting_room.client_disconnect_request.connect(remove_client)

	
# this gets called only by clients 
func connected_to_server():
	print("connected to server")
	# call register info on the server first
	#register_player_info.rpc_id(1, player_name.text, multiplayer.get_unique_id())
	register_player_info.rpc_id(1, GameManager.username, multiplayer.get_unique_id())


# this gets called only by clients 
func connection_failed():
	print("connection failed")

func _on_host_game_pressed():
	print("host game pressed")
	var host_info = server.start_server()
	$CanvasLayer/WaitingRoom/IPAddress.text = "IP Address: " + str(host_info[1])
	hostBtn.disabled = true
	hostBtn.visible = false
	register_player_info(GameManager.username, multiplayer.get_unique_id())
	print(GameManager.PLAYERS)
	server_browser.setup_server_broadcast(GameManager.username)
	#get_tree().change_scene_to_file("res://UI/Menus/Server Connecting/waiting_room.tscn")
	
	# move to waiting room
	server_browser.visible = false
	waiting_room.visible = true
	waiting_room.set_visibility(1)
	$CanvasLayer/BackBtn.visible = false
	$CanvasLayer/Servers.visible = false
	$CanvasLayer/IPBtn.visible = false
	$CanvasLayer/WaitingRoom/UserIDLabel.text = "User Id: " + str(multiplayer.get_unique_id())

func join_server_by_ip(ip):
	var peer = ENetMultiplayerPeer.new()
	#peer.create_client(ip, int(selected_port.text))
	peer.create_client(ip, 3296)
	multiplayer.set_multiplayer_peer(peer)
	$CanvasLayer/WaitingRoom/IPAddress.text = "IP Address: " + str(ip)
	# move to waiting room
	server_browser.visible = false
	$CanvasLayer/HostGame.visible = false
	$CanvasLayer/BackBtn.visible = false
	$CanvasLayer/IPBtn.visible = false
	$CanvasLayer/Servers.visible = false
	waiting_room.visible = true
	waiting_room.set_visibility(-1)
	$CanvasLayer/WaitingRoom/UserIDLabel.text = "User Id: " + str(multiplayer.get_unique_id())
	

func _on_start_game_btn_pressed():
	start_game.rpc()
	 # everybody will be notified to call their own start_game method

@rpc("any_peer", "call_local","reliable")
func start_game():
	var start_scene = load("res://Levels/Tutorial/tutorial.tscn").instantiate()
	get_tree().root.add_child(start_scene)
	print("started game" + str(multiplayer.get_unique_id()))
	server_browser.cleanup_browser()
	$CanvasLayer.visible = false
	self.hide()
	
@rpc("any_peer","reliable")
func register_player_info(player_name, id, character:String = "Dwight"):
	if not GameManager.PLAYERS.has(id):
		GameManager.PLAYERS[id] = {
			"name":player_name,
			"id":id,
			"Character": character #default character
		}
	# after the server received the connected player's info, the server broadcast
	# the info to the other players.
	if multiplayer.is_server():
		for playerID in GameManager.PLAYERS:
			register_player_info.rpc(GameManager.PLAYERS[playerID].name, playerID, GameManager.PLAYERS[playerID]["Character"])

# handle the case where a client clicks on "exit room" to leave the current session
# this is only done by the host. 
@rpc("any_peer","reliable")
func remove_client(client_id):
	print("trying to remove client:", client_id, "this id:", multiplayer.get_unique_id())
	if !multiplayer.is_server():
		print("remove client: not server, exiting wait room. ")
		remove_client.rpc_id(1, client_id)
		GameManager.PLAYERS.erase(client_id)
		# go back to lobby
		server_browser.visible = true
		$CanvasLayer/HostGame.visible = true
		$CanvasLayer/BackBtn.visible = true
		$CanvasLayer/Servers.visible = true
		$CanvasLayer/IPBtn.visible = true
		waiting_room.visible = false
		
	if multiplayer.get_unique_id() == 1:
		# remove the client peer
		if server.server_peer != null:
			server.server_peer.disconnect_peer(client_id)
		# remove the client peer from the game manager/player data
		GameManager.PLAYERS.erase(client_id)
		print("client removed, current players:", GameManager.PLAYERS)


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")


func _on_cancel_host_btn_pressed():
	server.close_server()
	# We need to tell the other players that are not in the server yet,
	# that the server has closed. So they can update their server browser. 
	server_browser.broadcast_server_closed() 


func _on_ip_btn_pressed():
	print("IP BTN pressed: opening direct server join scene")
	$CanvasLayer/DirectIPJoin/CanvasLayer.visible=true

func _on_disconnect_from_server():
	print("Disconnected from server.")
	GameManager.PLAYERS.clear()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	get_tree().reload_current_scene()

func _on_go_to_game_btn_pressed():
	print("pressed")
	load_select_scene.rpc(waiting_room.gameMode)

	
@rpc("any_peer","call_local","reliable")
func load_select_scene(gameMode):
	print("loading select scene")
	server_browser.cleanup_browser()
	if gameMode == 1:
		get_tree().change_scene_to_file("res://Levels/Tutorial/tutorial.tscn")
	elif gameMode == 2:
		get_tree().change_scene_to_file("res://UI/Menus/Level Select/party_select.tscn")
	elif gameMode == 3:
		print("Going to coop mode")
		get_tree().change_scene_to_file("res://UI/Menus/Level Select/coop_select.tscn")
	else:
		waiting_room.show_popup("no valid game mode selected!")
		
