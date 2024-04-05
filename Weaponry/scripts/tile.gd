extends RigidBody2D

var direction : Vector2
var explosion = preload("res://Weaponry/explosion.tscn")
const SPEED = 400.0
var collision_info
var shot_by : int

@export var goalpos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(1,0).rotated(rotation) * SPEED
	goalpos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Sync the block for non-main shooter
	if multiplayer.get_unique_id() == 1:
		collision_info = move_and_collide(linear_velocity * delta)
		goalpos = global_position
		# If recast, spawn tile
		if Input.is_action_just_pressed("recastTileGun") && multiplayer.get_unique_id() == shot_by:
			spawn_tile.rpc(position.x, position.y)
			# Deal with post-collision
		if collision_info:
			print("collided with a " , collision_info.get_collider().get_class())
			# If collided with tilemap, treat it as recast
			if collision_info.get_collider().get_class() == "TileMap":
				spawn_tile.rpc(position.x, position.y)
			# If collided with not tilemap, make disappear
			else:
				remove_tile.rpc()
	else:
		print(goalpos)
		global_position = lerp(global_position, goalpos, 1 - pow(0.001, 8*delta))
		# If recast, spawn tile
		if Input.is_action_just_pressed("recastTileGun") && multiplayer.get_unique_id() == shot_by:
			spawn_tile.rpc(position.x, position.y)


@rpc("any_peer","call_local","reliable")
func remove_tile():
	queue_free()

@rpc("any_peer","call_local","reliable")
func spawn_tile(pos_x, pos_y):
	# Send a signal to tilemap of level
	SignalBus.tilespawn.emit(pos_x, pos_y)
	queue_free()
