extends CharacterBody2D
signal pickedUp

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const PISTOL_KNOCKBACK_VELOCITY = 600
#const PISTOL_KNOCKBACK_RADIUS = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hasPistol = false
var mousePosVector: Vector2
var gunRotation
var above
@export var bullet :PackedScene
#@export var explosion :PackedScene

func _ready():
	$GunRotation/Pistol.visible = false
	add_to_group("players")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	elif is_on_floor(): # and Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = lerp(velocity.x, 0.0, 0.7)
	
	#if Input.is_action_pressed("right"):
		#velocity.x += 24
	#if Input.is_action_pressed("left"):
		#velocity.x += -24
		
	# This rotates the gun following the mouse
	mousePosVector = Vector2(get_global_mouse_position() - position)
	gunRotation = acos(mousePosVector.dot(Vector2(1,0)) / mousePosVector.length())
	if (get_global_mouse_position().y < position.y):
		gunRotation *= -1
	$GunRotation.rotation = gunRotation
	
	if Input.is_action_just_pressed("shoot") and hasPistol:
		# Shoot bullet.
		var b = bullet.instantiate()
		b.global_position = $GunRotation/BulletSpawn.global_position
		b.rotation_degrees = $GunRotation.rotation_degrees
		get_tree().root.add_child(b)
		
	move_and_slide()


func _on_pistol_body_entered(body):
	#print("entered")
	pickedUp.emit()
	hasPistol = true
	$GunRotation/Pistol.visible = true
	#$CollisionShape2D.set_deferred("disabled", true)
	

# pos:	position of explosion
# b:	min explosion force
# a:	max explosion force
# r:	exposion radius
func on_explosion(pos, b, a, r):
	
	print("explode in player")
	# Find explosion degree and radius.
	var diff = position - pos # Player position - explosion center position
	var radius = diff.length()
	print("radius: " + str(radius))
	
	# Knockback if within blast radius
	if (radius < r):
		# Degree of player current position from center of explosion
		var deg = acos(diff.dot(Vector2(1,0)) / diff.length())
		if (pos.y > position.y):
			deg *= -1
		print("degree: " + str(deg*180/PI))
		
		# Calculate force of explosion based on radius
		var knockback_force = -1 * radius * (a - b) / r + a
		
		# Knockback player from exposion
		var knockback_vector = Vector2.ZERO
		knockback_vector.y = sin(deg) 
		knockback_vector.x = cos(deg)
		print("knockback vector: " + str(knockback_vector))
		print("knockback force: " + str(knockback_force))
		velocity += knockback_vector * knockback_force
		print("velocity:" + str(velocity))
		print()
		knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.1)
