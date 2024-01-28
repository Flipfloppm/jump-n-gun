extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var knockback_lerp_const = 0.1
var regular_lerp_const = 0.9
var knockback_min_force = 200
var knockback_max_force = 600
var knockback_radius = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var hasRocketLauncher
#var hasGrenadeLauncher
var hasWeapon = false
var currWeapon = ""
var knockingBack = false
var mousePosVector: Vector2
var gunRotation
var above
var reloadTime = 0.8
@onready var camera = $Camera2D
@export var rocket :PackedScene
@export var grenade :PackedScene


func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	SignalBus.weapon_entered.connect(_on_rocket_body_entered)
	$GunRotation/RocketLauncher.visible = false
	$GunRotation/GrenadeLauncher.visible = false
	hasWeapon = false
	#hasRocketLauncher = false
	add_to_group("players")
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.make_current()


# Set the player variables
func _set_var(var_name: String, var_val: float):
	match var_name:
		"knockback_lerp_const":
			knockback_lerp_const = var_val
		"regular_ler_const":
			regular_lerp_const = var_val
		"knockback_min_force":
			knockback_min_force = var_val
		"knockback_max_force":
			knockback_max_force = var_val
		"knockback_radius":
			knockback_radius = var_val
			

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
			velocity.x = lerp(velocity.x, 0.0, knockback_lerp_const)
		else:
			velocity.x = lerp(velocity.x, 0.0, regular_lerp_const)
			
		# This rotates the gun following the mouse
		mousePosVector = Vector2(get_global_mouse_position() - position)
		gunRotation = acos(mousePosVector.dot(Vector2(1,0)) / mousePosVector.length())

		
		if (get_global_mouse_position().y < position.y):
			gunRotation *= -1
		$GunRotation.rotation = gunRotation
		
		if Input.is_action_just_pressed("shoot"):
			match currWeapon:
				"RocketLauncher":
					if reloadTime <= 0:
						rocketFire.rpc()
				"GrenadeLauncher":
					grenadeFire.rpc()
		
		move_and_slide()


func _on_rocket_body_entered(weaponBody, body):
	var weaponName = weaponBody.to_string().get_slice(" ", 0)
	if body != self:
		return 
	if hasWeapon:
		return
	hasWeapon = true
	match weaponName:
		"Rocket":
			currWeapon = "RocketLauncher"
			SignalBus.picked_up.emit(weaponBody)
			#hasRocketLauncher = true
			$GunRotation/RocketLauncher.visible = true
			#if hasGrenadeLauncher:
				#return
			#if !hasRocketLauncher: 
				#SignalBus.picked_up.emit(weaponBody)
				#hasRocketLauncher = true
				#$GunRotation/RocketLauncher.visible = true
		"Grenade":
			currWeapon = "GrenadeLauncher"
			SignalBus.picked_up.emit(weaponBody)
			#hasGrenadeLauncher = true
			$GunRotation/GrenadeLauncher.visible = true
			#if hasRocketLauncher:
				#return
			#if !hasGrenadeLauncher: 
				#SignalBus.picked_up.emit(weaponBody)
				#hasGrenadeLauncher = true
				#$GunRotation/GrenadeLauncher.visible = true
	
	

# pos:	position of explosion
func on_explosion(pos):
	# Set explosion values.
	var a = knockback_min_force
	var b = knockback_max_force
	var r = knockback_radius
	
	# Find explosion degree and radius.
	var diff = position - pos # Player position - explosion center position
	var radius = diff.length()
	
	# Knockback if within blast radius
	if (radius < r):
		knockingBack = true
		# Degree of player current position from center of explosion
		var deg = acos(diff.dot(Vector2(1,0)) / diff.length())
		if (pos.y > position.y):
			deg *= -1
		
		# Calculate force of explosion based on radius
		var knockback_force = -1 * radius * (a - b) / r + a
		
		# Knockback player from exposion
		var knockback_vector = Vector2.ZERO
		knockback_vector.y = sin(deg) 
		knockback_vector.x = cos(deg)
		velocity += knockback_vector * knockback_force
		knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.1)
	await get_tree().create_timer(0.5).timeout
	knockingBack = false

@rpc("any_peer","call_local")
func rocketFire():
	# Shoot bullet.
	reloadTime = 0.8
	var r = rocket.instantiate()
	r.global_position = $GunRotation/RocketSpawn.global_position
	r.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(r)
	
@rpc("any_peer","call_local")
func grenadeFire():
	# Shoot bullet.
	#reloadTime = 0.8
	var g = grenade.instantiate()
	g.global_position = $GunRotation/GrenadeSpawn.global_position
	g.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(g)
