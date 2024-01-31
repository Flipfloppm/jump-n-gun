extends Control

@onready var server = $CenterContainer/VBoxContainer/Server
@onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameEdit
@onready var selected_IP = $CenterContainer/VBoxContainer/GridContainer/IPEdit
@onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortEdit
@onready var joinBtn = $JoinBtn
@onready var hostBtn = $CenterContainer/VBoxContainer/Server/HostGame

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
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
	
func _on_join_btn_pressed():
	print("join pressed")
	var fpeer = ENetMultiplayerPeer.new()
	peer.create_client(selected_IP.text, int(selected_port.text))
	multiplayer.set_multiplayer_peer(peer)
	joinBtn.disabled = true

func _on_start_game_btn_pressed():
	get_tree().change_scene_to_file("res://Levels/level_selection/World_Select.tscn")
	 # everybody will be notified to call their own start_game method

@rpc("any_peer", "call_local")
func start_game():
	var start_scene = load("res://Levels/tutorial.tscn").instantiate()
	get_tree().root.add_child(start_scene)
	print("started game" + str(multiplayer.get_unique_id()))
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




