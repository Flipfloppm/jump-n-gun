extends CanvasLayer

@onready var _rocketLauncherAnimation = $RocketLauncherReload
@onready var _grenadeLauncherAnimation = $GrenadeLauncherReload
@onready var _grenadeLauncherAmmoText = $GrenadeLauncherReload/Ammo
var grenadeLauncherAmmo = 6
var grenadeReloading = false
var grenadeReloadTimer
var currWeapon
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.fired.connect(_on_fired)
	SignalBus.weapon_swap.connect(_on_weapon_swap)
	_rocketLauncherAnimation.visible = false
	_grenadeLauncherAnimation.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _grenadeLauncherAnimation.animation_finished and grenadeReloading:
		grenadeReloading = false
		grenadeLauncherAmmo = 6
		_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)

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
