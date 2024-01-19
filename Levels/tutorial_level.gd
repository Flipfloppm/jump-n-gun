extends Node2D

@export var PLAYERSCENE: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("level ready")
	print($StaticRocketLauncher)
	var index = 0
	print("players:" + str(GameManager.PLAYERS))
	for i in GameManager.PLAYERS:
		var cur_player = PLAYERSCENE.instantiate()
		cur_player.name = str(GameManager.PLAYERS[i].id)
		add_child(cur_player)
		for spawn_position in get_tree().get_nodes_in_group("PlayerSpawnPosition"):
			if spawn_position.name == str(index):
				cur_player.global_position = spawn_position.global_position
				print("spawned 1 player: " + str(multiplayer.get_unique_id()) + "at: " + str(index))
		index += 1
	

