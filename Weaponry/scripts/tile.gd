extends RigidBody2D

var direction : Vector2
var explosion = preload("res://Weaponry/explosion.tscn")
var collision_info
const SPEED = 600.0

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(1,0).rotated(rotation) * SPEED
	#linear_velocity = Vector2(1,0).rotated(rotation) * linear_velocity
	print("lin velocity: ", linear_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(multiplayer.get_unique_id(), ", coords: ", position, ";  velocity: ", linear_velocity)
	var collision_info = move_and_collide(linear_velocity * delta)
	# Deal with post-collision
	if collision_info:
		print(collision_info)
		print("Collided with a  ", collision_info.get_collider())
		# If collided with tilemap, treat it as recast
		if collision_info.get_collider().get_class() == "TileMap":
			spawn_tile.rpc(position.x, position.y)
		# If collided with not tilemap, make disappear
		else:
			queue_free()
	# If recast, spawn tile
	if Input.is_action_just_pressed("recastTileGun"):
		spawn_tile.rpc(position.x, position.y)
	

@rpc("any_peer","call_local")
func spawn_tile(pos_x, pos_y):
	# TODO: Check if something else is where we plan to spawn. If something else is there, don't spawn anything.
	# Cast position to a tilemap position, and create new tile in tilemap.
	# Send a signal to tilemap of level
	SignalBus.tilespawn.emit(pos_x, pos_y)
	queue_free()


#func _on_timer_timeout():
	#var e = explosion.instantiate()
	#e.global_position = get_position()
	#get_tree().root.add_child(e)
	#queue_free()
