extends RigidBody2D

const SPEED = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var explosion = preload("res://Items/explosion.tscn")
var collided = false

var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#direction = Vector2(1,0).rotated(rotation)
	#linear_velocity = direction * linear_velocity
	#print("velocity:" + str(linear_velocity))
	linear_velocity = Vector2(1,0).rotated(rotation) * SPEED
	mass = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal())
		linear_velocity.x *= 0.7
		linear_velocity.y *= 0.5
		# Stop moving upon collision.
		freeze = true
		collided = true
	if collided:
		linear_velocity = Vector2.ZERO
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
	#if !collided:
		##linear_velocity = SPEED * direction
		#collision = move_and_collide(delta * linear_velocity)
		#if collision:
			## Stop moving upon collision.
			#freeze = true
			#linear_velocity = linear_velocity.bounce(collision.get_normal())
			#linear_velocity.x *= 0.7
			#linear_velocity.y *= 0.5
			#collided = true
			#linear_velocity = Vector2.ZERO
			#timer = Timer.new()
			#add_child(timer)
			#timer.wait_time = 3.0
			#timer.one_shot = true
			#timer.connect("timeout", _on_timer_timeout)
			#timer.start()
	#else:
		#linear_velocity = Vector2.ZERO
		#if Input.is_action_just_pressed("c4detonate"):
			## Stop timer and explode
			#timer.stop()
			#_on_timer_timeout()
			#


func _on_timer_timeout():
	var e = explosion.instantiate()
	e.global_position = get_position()
	get_tree().root.add_child(e)
	queue_free()
	SignalBus.detonated.emit()
