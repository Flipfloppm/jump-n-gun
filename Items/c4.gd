extends StaticBody2D

const SPEED = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var collision: KinematicCollision2D
var explosion = preload("res://Items/explosion.tscn")
var collided = false

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(1,0).rotated(rotation)
	#print("velocity:" + str(linear_velocity))
	#linear_velocity = Vector2(1,0).rotated(rotation) * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	constant_linear_velocity = SPEED * direction
	collision = move_and_collide(delta * velocity)
	#if collided:
		#velocity = Vector2.ZERO
	# When collide, stop moving and start timer.
	if collision:
		collided = true
		constant_linear_velocity = Vector2.ZERO
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 3.0
		timer.one_shot = true
		timer.connect("timeout", _on_timer_timeout)
		timer.start()
		#if collision.get_collider().has_method("hit"):
			#collision.get_collider().hit(collision.get_position() - collision.get_normal())
		#var e = explosion.instantiate()
		#e.global_position = collision.get_position()
		#get_tree().root.add_child(e)
		#delete the projectile if it hits something
		#queue_free()
	#move_and_slide()


func _on_timer_timeout():
	var e = explosion.instantiate()
	e.global_position = get_position()
	get_tree().root.add_child(e)
	queue_free()
