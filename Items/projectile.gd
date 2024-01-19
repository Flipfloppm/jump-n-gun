extends CharacterBody2D


const SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var collision: KinematicCollision2D

@onready var _animated_sprite = $Rocket

func _ready():
	direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	velocity = SPEED * direction # Gravity so that the bullet falls.
	# Make bullet disappear if it hits anything
	collision = move_and_collide(delta * velocity)
	if collision:
		# delete the bullet if it hits something
		queue_free()
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(collision.get_position() - collision.get_normal())
	move_and_slide()
	
func _process(delta): 
	# play the animation for a rocket, unsure what happens if you spawn a bullet
	_animated_sprite.play("default")
