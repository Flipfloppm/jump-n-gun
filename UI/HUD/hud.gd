extends CanvasLayer

@onready var _rocketLauncherAnimation = $RocketLauncherReload
@onready var _grenadeLauncherAnimation = $GrenadeLauncherReload
@onready var _grenadeLauncherAmmoText = $GrenadeLauncherReload/Panel/Ammo
@onready var _healthBar = $HealthBar
@onready var _charHead = $HealthBar/CharacterHead
var grenadeLauncherAmmo = 6
var grenadeReloading = false
var grenadeReloadTimer
var currWeapon
var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.fired.connect(_on_fired)
	SignalBus.weapon_swap.connect(_on_weapon_swap)
	SignalBus.hurt.connect(_on_hurt)
	_rocketLauncherAnimation.visible = false
	_grenadeLauncherAnimation.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _grenadeLauncherAnimation.animation_finished and grenadeReloading:
		grenadeReloading = false
		grenadeLauncherAmmo = 6
		_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)

func setup(charName):
	match charName:
		"Ron":
			_charHead.texture = load("res://Art/UI/HUD/Character Heads/ronald-head.png")
		"Dick":
			_charHead.texture = load("res://Art/UI/HUD/Character Heads/cheney-head.png")
		"Dwight":
			_charHead.texture = load("res://Art/UI/HUD/Character Heads/dwight-head.png")
		"Bush":
			_charHead.texture = load("res://Art/UI/HUD/Character Heads/bush-head.png")
	
func _on_fired():
	match currWeapon:
		"Rocket":
			_rocketLauncherAnimation.play("default")
		"Grenade":
			grenadeLauncherAmmo -= 1
			_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)
			if grenadeLauncherAmmo == 0:
				_grenadeLauncherAnimation.play("default")
				grenadeReloading = true

	
func _on_weapon_swap(weaponName):
	currWeapon = weaponName
	match weaponName:
		"Rocket":
			_rocketLauncherAnimation.visible = true
			_grenadeLauncherAnimation.visible = false
		"Grenade":
			_rocketLauncherAnimation.visible = false
			_grenadeLauncherAnimation.visible = true
			_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)
			
func _on_hurt():
	health -= 1
	_healthBar.frame += 1
	
	
