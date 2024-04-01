extends CharacterBody2D
signal explode


const SPEED = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2
var collision: KinematicCollision2D
var explosion = preload("res://Weaponry/explosion.tscn")

@onready var _animated_sprite = $Rocket

@export var goalpos : Vector2

func _ready():
	direction = Vector2(1,0).rotated(rotation)
	goalpos = global_position

func _physics_process(delta):
	if multiplayer.get_unique_id() == 1:
		velocity = SPEED * direction # Gravity so that the bullet falls.
		collision = move_and_collide(delta * velocity)
		if collision:
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit(collision.get_position() - collision.get_normal())
			var e = explosion.instantiate()
			e.global_position = collision.get_position()
			get_tree().root.add_child(e)
			#delete the projectile if it hits something
			remove_rocket.rpc()
		move_and_slide()
		goalpos = global_position
	else:
		global_position = lerp(global_position, goalpos, 1 - pow(0.001, 8*delta))



func _process(_delta): 
	# play the animation for a rocket, unsure what happens if you spawn a bullet
	_animated_sprite.play("default")

@rpc("any_peer","call_local","reliable")
func remove_rocket():
	queue_free()
