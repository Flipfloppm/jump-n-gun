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
	SignalBus.game_over.connect(_on_game_over)
	if multiplayer.get_unique_id() == 1:
		await get_tree().create_timer(2).timeout
		spawn_players.rpc()
	else:
		await get_tree().create_timer(1).timeout
	print("level ready")
	

func _on_game_over(name):
	if name == "":
		$"CanvasLayer/Game Over".visible = true
	else:
		$"CanvasLayer/Game Over".winner(name)
		$"CanvasLayer/Game Over".visible = true

@rpc("any_peer", "call_local", "reliable")
func spawn_players():
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
		print(cur_player)
		cur_player.name = str(GameManager.PLAYERS[i].id)
		GameManager.PLAYERS[i]["body"] = cur_player
		add_child(cur_player)
		for spawn_position in get_tree().get_nodes_in_group("PlayerSpawnPosition"):
			if spawn_position.name == str(index):
				cur_player.global_position = spawn_position.global_position
				print("spawned 1 player: " + str(multiplayer.get_unique_id()) + "at: " + str(index))
		index += 1
	HUD.setup(GameManager.PLAYERS[multiplayer.get_unique_id()]["Character"])
	
