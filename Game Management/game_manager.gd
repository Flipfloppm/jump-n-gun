extends Node

var PLAYERS = {}
var username: String

func _ready():
	multiplayer.server_disconnected.connect(_on_disconnect_from_server)

func _on_disconnect_from_server():
	print("Clearing game manager")
	PLAYERS.clear()

func setUsername(input):
	#TODO: Add input validation
	username = input
	
