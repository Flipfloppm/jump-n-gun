extends RigidBody2D

const SPEED = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var explosion = preload("res://Weaponry/explosion.tscn")
var collision : KinematicCollision2D
var collided = false # If the object has hit another object.
var collided_body # The body that this collided with.
var shot_by : int

@export var goalpos : Vector2
@export var time_left : int 


# Called when the node enters the scene tree for the first time.
func _ready():
	freeze = false
	linear_velocity = Vector2(1,0).rotated(rotation) * SPEED
	goalpos = global_position
	time_left = 3


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sync the block for non-main shooter
	if multiplayer.get_unique_id() == 1:
		var collision = move_and_collide(linear_velocity * delta)
		if collision:
			collided_body = collision.get_collider()
			if collided_body.get_class() == "TileMap":
				# Stop moving upon collision with tilemap.
				freeze = true
				collided = true
			else:
				# Bounce
				linear_velocity = linear_velocity.bounce(collision.get_normal().normalized())
		if collided:
			linear_velocity = Vector2.ZERO
			time_left -= delta
			if time_left < 0 || (Input.is_action_just_pressed("c4detonate") && multiplayer.get_unique_id() == shot_by):
				c4_detonate.rpc()
		goalpos = global_position
	else:
		global_position = lerp(global_position, goalpos, 1 - pow(0.001, 8*delta))
		if Input.is_action_just_pressed("c4detonate") && multiplayer.get_unique_id() == shot_by:
			c4_detonate.rpc()


@rpc("any_peer","call_local")
func c4_detonate():
	var e = explosion.instantiate()
	e.global_position = get_position()
	get_tree().root.add_child(e)
	queue_free()
	SignalBus.c4detonated.emit()
