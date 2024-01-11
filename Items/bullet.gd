extends CharacterBody2D


const SPEED = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2

func _ready():
	direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	velocity = SPEED * direction # Gravity so that the bullet falls.
	# Make bullet disappear if it's in terrain.
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		hide()


	move_and_slide()
