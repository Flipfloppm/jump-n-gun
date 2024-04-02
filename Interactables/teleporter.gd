#extends Node2D
#
#signal teleporter_dropped(teleporter)
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#connect("teleporter_dropped", get_parent(), "_on_teleporter_dropped")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
## Reference to the other teleporter
#var linked_teleporter = null
#
## Signal to notify when a player enters the teleporter
#signal player_entered(player)
#
## Function to link the other teleporter
#func link_teleporter(other_teleporter):
	#linked_teleporter = other_teleporter
	#linked_teleporter.linked_teleporter = self
#
## Function to teleport the player
#func teleport_player(player):
	#if linked_teleporter:
		#player.global_position = linked_teleporter.global_position
#
#func _on_Teleporter_body_entered(body):
	## Check if the entering body is a player
	##if body.is_in_group("Player"):
		##emit_signal("player_entered", body)
	#if body.has_method("teleport"):
		#body.teleport()
#
#func _on_Teleporter_body_exited(body):
	## Check if the exiting body is a player
	#if body.is_in_group("Player"):
		## Reset the player's state or perform any necessary cleanup
		#pass
#
#
#
#func _input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		#if get_overlapping_bodies().has(get_tree().get_nodes_in_group("Player")[0]):
			## Teleporter picked up
			#queue_free()
#
#
#func drop_teleporter(position):
	#var teleporter = load("res://path/to/Teleporter.tscn").instance()
	#teleporter.global_position = position
	#get_parent().add_child(teleporter)
	#emit_signal("teleporter_dropped", teleporter)
