extends RigidBody2D

const SPEED = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var explosion = preload("res://Weaponry/explosion.tscn")
var collision : KinematicCollision2D
var collided = false # If the object has hit another object.
var collided_body # The body that this collided with.
var collider_position : Vector2
var collision_position : Vector2
var shot_by : int

@export var goalpos : Vector2
@export var time_left : int 


# Called when the node enters the scene tree for the first time.
func _ready():
	set_lock_rotation_enabled(true)
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	set_freeze_mode(FREEZE_MODE_KINEMATIC)
	freeze = false
	if multiplayer.get_unique_id() == 1:
		linear_velocity = Vector2(1,0).rotated(rotation) * SPEED
	goalpos = global_position
	time_left = 3


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#collision = move_and_collide(linear_velocity * delta)
	#if Input.is_action_just_pressed("c4detonate") && multiplayer.get_unique_id() == shot_by:
		#c4_detonate.rpc()
	# Sync the block for non-main shooter
	if multiplayer.get_unique_id() == 1:
		if !collision:
			collision = move_and_collide(linear_velocity * delta)
		else:
			collided_body = collision.get_collider()
			# Parse collision
			if collided_body.get_class() == "TileMap":
				# Move c4 deeper into collision object tilemap
				collision_position = collision.get_position()
				collider_position = collided_body.position
				if collider_position.x < collision_position.x:
					collision_position.x -= 1
				else:
					collision_position.x += 1
				if collider_position.y < collision_position.y:
					collision_position.y -= 1
				else:
					collision_position.y += 1
				# Stop moving upon collision with tilemap.
				set_sleeping(true)
				#linear_velocity = Vector2.ZERO
				collided = true
			else:
				# Bounce
				linear_velocity = linear_velocity.bounce(collision.get_normal().normalized())
		if is_sleeping():
			position = collision_position
			#set_sleeping(false)
			#collided = false
		if collided:
			#linear_velocity = Vector2.ZERO
			time_left -= delta
			if time_left < 0 || (Input.is_action_just_pressed("c4detonate") && multiplayer.get_unique_id() == shot_by):
				c4_detonate.rpc()
		goalpos = global_position
	else:
		global_position = lerp(global_position, goalpos, 1 - pow(0.001, 8*delta))
		#if !is_sleeping:
			#global_position = lerp(global_position, goalpos, 1 - pow(0.001, 8*delta))
		#else:
			#print("non host sleeping")
		if Input.is_action_just_pressed("c4detonate") && multiplayer.get_unique_id() == shot_by:
			c4_detonate.rpc()


@rpc("any_peer","call_local")
func c4_detonate():
	var e = explosion.instantiate()
	e.global_position = get_position()
	get_tree().root.add_child(e)
	queue_free()
	SignalBus.c4detonated.emit()


func _on_body_exited(body):
	print("exited")
	set_sleeping(false)
	collided = false
	collision = null

