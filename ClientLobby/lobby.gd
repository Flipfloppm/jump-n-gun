extends Control

@onready var server = $Server
@onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameEdit
@onready var selected_IP = $CenterContainer/VBoxContainer/GridContainer/IPEdit
@onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortEdit
@onready var joinBtn = $CenterContainer/VBoxContainer/JoinBtn

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
# this gets called only by clients 
func connected_to_server():
	print("connected to server")
	# call register info on the server first
	#register_player_info.rpc_id(1, $PlayerNameTextBox.text, multiplayer.get_unique_id())

# this gets called only by clients 
func connection_failed():
	print("connection failed")

func _on_host_game_pressed():
	var host_info = server.start_server()
	selected_port.text = str(host_info[0])
	selected_IP.text = str(host_info[1])
	joinBtn.disabled = true
	
func _on_join_btn_pressed():
	print("join pressed")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(selected_IP.text, int(selected_port.text))
	multiplayer.set_multiplayer_peer(peer)

func _on_start_game_btn_pressed():
	start_game.rpc() # everybody will be notified to call their own start_game method

@rpc("any_peer", "call_local")
func start_game():
	var start_scene = load("res://Levels/test_level.tscn").instantiate()
	get_tree().root.add_child(start_scene)
	print("started game" + str(multiplayer.get_unique_id()))
	self.hide()



