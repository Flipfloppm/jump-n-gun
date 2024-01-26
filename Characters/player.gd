extends CharacterBody2D
signal pickedUp

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hasRocketLauncher = false
var knockingBack = false
var mousePosVector: Vector2
var gunRotation
var above
var reloadTime = 0.8
@onready var camera = $Camera2D
@export var rocket :PackedScene


func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	SignalBus.weapon_entered.connect(_on_rocket_body_entered)
	$GunRotation/RocketLauncher.visible = false
	add_to_group("players")
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.make_current()


func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		reloadTime -= delta
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
		elif knockingBack:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
		else:
			#knockingBack = false
			velocity.x = lerp(velocity.x, 0.0, 0.9)
		#elif is_on_floor(): # and Input.is_action_just_released("left") or Input.is_action_just_released("right"):
			##velocity.x = move_toward(velocity.x, 0, SPEED)
			#if knockingBack:
				#velocity.x = lerp(velocity.x, 0.0, 0.1)
			#else:
				#velocity.x = lerp(velocity.x, 0.0, 0.7)
			
		# This rotates the gun following the mouse
		mousePosVector = Vector2(get_global_mouse_position() - position)
		gunRotation = acos(mousePosVector.dot(Vector2(1,0)) / mousePosVector.length())

		
		if (get_global_mouse_position().y < position.y):
			gunRotation *= -1
		$GunRotation.rotation = gunRotation
		
		if Input.is_action_just_pressed("shoot") and hasRocketLauncher and reloadTime <= 0:
			fire.rpc()
		move_and_slide()


func _on_rocket_body_entered(body):
	print("body" + str(body) + "self" + str(self))
	print("entered" + str(multiplayer.get_unique_id()))
	if body != self:
		return 
	pickedUp.emit()
	hasRocketLauncher = true
	$GunRotation/RocketLauncher.visible = true
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
		knockingBack = true
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
	await get_tree().create_timer(0.5).timeout
	knockingBack = false

@rpc("any_peer","call_local")
func fire():
	# Shoot bullet.
	reloadTime = 0.0
	var r = rocket.instantiate()
	r.global_position = $GunRotation/RocketSpawn.global_position
	r.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(r)
	

# Defines behavior for player die
func die():
	print("player die")
	# TODO: checkpoints
	position = Vector2(41, 212)
