extends Node

var server_peer
var SELECTED_IP = "127.0.0.1"
var SELECTED_PORT = 3296
var MAX_PLAYERS = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	if "--server" in OS.get_cmdline_args():
		start_server()
		

func _on_host_game_pressed():
	start_server()

func start_server():
	server_peer = ENetMultiplayerPeer.new()
	var err = server_peer.create_server(SELECTED_PORT, MAX_PLAYERS)
	if err != OK:
		print("cannot host:" + err)
		return
	multiplayer.set_multiplayer_peer(server_peer)
	print("started server at: " + str(IP.get_local_addresses()))
	return [SELECTED_PORT, SELECTED_IP]

# this gets called on both the server and client when someone connects
func peer_connected(id):
	print("Player connected: " + str(id))

# this gets called on both the server and client when someone connects
func peer_disconnected(id):
	print("Player disconnected: " + str(id))


