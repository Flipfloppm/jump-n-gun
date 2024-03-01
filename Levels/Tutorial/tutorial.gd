extends Node2D

var CheneyScene = preload("res://Characters/cheney.tscn")
var BushScene = preload("res://Characters/bush.tscn")
var RonnieScene = preload("res://Characters/ronnie.tscn")
var DwightScene = preload("res://Characters/dwight.tscn")
var paused = false
@onready var HUD = $HUD
var cur_player


# Called when the node enters the scene tree for the first time.
func _ready():
	print("level ready")
	var index = 0
	print("players:" + str(GameManager.PLAYERS))
	for i in GameManager.PLAYERS:
		match GameManager.PLAYERS[i]["Character"]:
			"Dwight":
				cur_player = DwightScene.instantiate()
			"Ron":
				cur_player = RonnieScene.instantiate()
			"Bush":
				cur_player = BushScene.instantiate()
			"Dick":
				cur_player = CheneyScene.instantiate()
		cur_player.name = str(GameManager.PLAYERS[i].id)
		add_child(cur_player)
		for spawn_position in get_tree().get_nodes_in_group("PlayerSpawnPosition"):
			if spawn_position.name == str(index):
				cur_player.global_position = spawn_position.global_position
				print("spawned 1 player: " + str(multiplayer.get_unique_id()) + "at: " + str(index))
		index += 1
	HUD.setup(GameManager.PLAYERS[multiplayer.get_unique_id()]["Character"])
	
