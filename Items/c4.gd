extends RigidBody2D

const SPEED = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var explosion = preload("res://Items/explosion.tscn")
var collision : KinematicCollision2D
var collided = false # If the object has hit another object.
var collided_body # The body that this collided with.
# (used when sticked) Transform (tr) at the collision instant (ci) from the collider to the ball
var tr_ci_collider_to_ball = Transform2D()

var physics_changed = false

var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Only 1 collision allowed.
	freeze = false
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	set_mass(1.0)
	
	linear_velocity = Vector2(1,0).rotated(rotation) * SPEED
	
	## Apply Godot physics at first
	set_use_custom_integrator(false) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !collided:
		collision = move_and_collide(linear_velocity * delta)
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal())
		linear_velocity.x *= 0.7
		linear_velocity.y *= 0.5
		 #Stop moving upon collision.
		#freeze = true
		collided = true
		collided_body = collision.get_collider()
	if collided:
		#make it not collidable anymore
		set_collision_layer_value(1,0)
		#set_mass(0.001)
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = 3.0
		timer.one_shot = true
		timer.connect("timeout", _on_timer_timeout)
		timer.start()
		if Input.is_action_just_pressed("c4detonate"):
			# Stop timer and explode
			timer.stop()
			_on_timer_timeout()


func _integrate_forces(body_state):
	# Handle tilemap collisions
	if collided_body && physics_changed==false:
		# Ignore Godot physics once it sticks
		set_use_custom_integrator(true) 
		# For debug, check on which we are sticking
		print("The ball is sticking on a ", collided_body)
		# Some transforms (tr) at the collision instant (ci)
		var tr_ci_world_to_ball = get_global_transform() # from the world coordinate system to the ball coordinate system
		var tr_ci_world_to_collider = collided_body.get_global_transform() # from the world cs to the collider cs
		tr_ci_collider_to_ball = tr_ci_world_to_collider.inverse() * tr_ci_world_to_ball 
		physics_changed = true
	# Apply changed physics
	elif physics_changed==true:
		global_transform = collided_body.get_global_transform() * tr_ci_collider_to_ball


func _on_timer_timeout():
	var e = explosion.instantiate()
	e.global_position = get_position()
	get_tree().root.add_child(e)
	queue_free()
	SignalBus.detonated.emit()
