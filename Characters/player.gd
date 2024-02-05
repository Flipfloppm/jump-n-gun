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
var hasWeaponsDict = {"Rocket": false, "Grenade": false}
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
	hasWeaponsDict["Rocket"] = false
	hasWeaponsDict["Grenade"] = false
	add_to_group("players")
	#set_wall_min_slide_angle(0.785398)
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.make_current()


# Set the player variables
func set_var(var_name: String, var_val: float):
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
		# TODO: Set floor normals depending on where standing for diagonal sliding

		reloadTime -= delta
		# Add the gravity for when jumping.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.	
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		elif knockingBack: # For knockback stopping
			velocity.x = lerp(velocity.x, 0.0, knockback_lerp_const)
		else: # Regular stopping
			velocity.x = lerp(velocity.x, 0.0, regular_lerp_const)
			
		# This rotates the gun following the mouse
		mousePosVector = Vector2(get_global_mouse_position() - position)
		gunRotation = acos(mousePosVector.dot(Vector2(1,0)) / mousePosVector.length())

		# Handle gun rotation
		if (get_global_mouse_position().y < position.y):
			gunRotation *= -1
		$GunRotation.rotation = gunRotation
		
		# Handle shooting
		if Input.is_action_just_pressed("shoot"):
			if reloadTime <= 0:
				fire.rpc()
		
		# Handle differnt guns
		if Input.is_action_just_pressed("selectRocketLauncher") && hasWeaponsDict["Rocket"]:
			print("selected rocket")
			select_weapon.rpc("Rocket")
		elif Input.is_action_just_pressed("selectGrenadeLauncher") && hasWeaponsDict["Grenade"]:
			print("selected grenade")
			select_weapon.rpc("Grenade")
		
		# Player move
		move_and_slide()


func _on_rocket_body_entered(weaponBody, body):
	var weaponName = weaponBody.to_string().get_slice(" ", 0)
	if body != self:
		return 
	# For now, player can only have one weapon.
	# TODO: later, make it so that player can have multiple weapons?
	if hasWeaponsDict[weaponName]:
		return
	# Pick up weapon
	SignalBus.picked_up.emit(weaponBody)
	select_weapon.rpc(weaponName)
	hasWeaponsDict[weaponName] = true


# Set current weapon and weapon variables
# This function allow for easier transition to having weapon inventory if needed
@rpc("any_peer", "call_local")
func select_weapon(weaponName: String):
	match weaponName:
		"Rocket":
			currWeapon = "RocketLauncher"
			knockback_min_force = 200
			knockback_max_force = 600
			knockback_radius = 100
			$GunRotation/GrenadeLauncher.visible = false
			$GunRotation/RocketLauncher.visible = true
		"Grenade":
			currWeapon = "GrenadeLauncher"
			knockback_min_force = 200
			knockback_max_force = 600
			knockback_radius = 100
			$GunRotation/RocketLauncher.visible = false
			$GunRotation/GrenadeLauncher.visible = true
	pass

# pos: position of explosion
func on_explosion(pos):
	# Find explosion degree and radius.
	var diff = position - pos # Player position - explosion center position
	var radius = diff.length()
	
	# Knockback if within blast radius
	if (radius < knockback_radius):
		knockingBack = true
		# Degree of player current position from center of explosion
		var deg = acos(diff.dot(Vector2(1,0)) / diff.length())
		if (pos.y > position.y):
			deg *= -1
		
		# Calculate force of explosion based on radius
		var knockback_force = -1 * radius * (knockback_min_force - knockback_max_force) / knockback_radius + knockback_min_force
		
		# Knockback player from exposion
		var knockback_vector = Vector2.ZERO
		knockback_vector.y = sin(deg) 
		knockback_vector.x = cos(deg)
		velocity += knockback_vector * knockback_force
		knockback_vector = lerp(knockback_vector, Vector2.ZERO, 0.1)
	# After knockback, reset physics
	await get_tree().create_timer(0.5).timeout
	knockingBack = false


@rpc("any_peer","call_local")
func fire():
	# Shoot bullet.
	var projectile
	match currWeapon:
		"RocketLauncher":
			reloadTime = 0.8
			projectile = rocket.instantiate()
		"GrenadeLauncher":
			projectile = grenade.instantiate()
		_:
			return
	projectile.global_position = $GunRotation/ProjectileSpawn.global_position
	projectile.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(projectile)


# Defines behavior for player die
func die():
	print("player die")
	# TODO: Set player respawn point + make animation for player respawn?
	position = Vector2(41, 212)
