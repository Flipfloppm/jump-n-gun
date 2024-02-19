extends RigidBody2D

var direction : Vector2
var explosion = preload("res://Items/explosion.tscn")
var collision_info
# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(1,0).rotated(rotation) * linear_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	# If collided with something, treat it as if recast
	if collision_info:
		spawn_tile(position.x, position.y)
	# If recast, spawn tile
	if Input.is_action_just_pressed("recastTileGun"):
		spawn_tile(position.x, position.y)
	

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
