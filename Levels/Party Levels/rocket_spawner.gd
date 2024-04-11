#extends MultiplayerSpawner
#
#const RocketScene = preload("res://Weaponry/rocket.tscn")
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#
## Initialize spawner
#
#
#func _on_tree_entered():
	#var spawner := $RocketSpawner
	#spawner.spawn_function = _spawn_rocket
	#
#func _spawn_rocket(id):
	#var rocket := RocketScene.instantiate()
	#rocket.get_node("Rocket").set_multiplayer_authority(id)
	#rocket.peer_id = id
	#return rocket
#
#func add_rocket(id):
	#$RocketSpawner.spwan(id)
