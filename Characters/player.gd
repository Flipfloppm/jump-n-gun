extends CharacterBody2D
signal pickedUp

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const PISTOL_KNOCKBACK_VELOCITY = 600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hasPistol = false
var mousePosVector: Vector2
var gunRotation
var above
@export var bullet :PackedScene

func _ready():
	$GunRotation/Pistol.visible = false
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
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
			
			# Knockback player.
			var knockback_vector = Vector2.ZERO
			var knockback_rads = $GunRotation.rotation + PI
			knockback_vector.y = sin(knockback_rads) * 0.5
			knockback_vector.x = cos(knockback_rads)
			print(knockback_vector)
			velocity += knockback_vector * PISTOL_KNOCKBACK_VELOCITY
			print(velocity)
			print()
			knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.1)
		move_and_slide()


func _on_pistol_body_entered(body):
	print("entered")
	pickedUp.emit()
	hasPistol = true
	$GunRotation/Pistol.visible = true
	#$CollisionShape2D.set_deferred("disabled", true)
