extends CanvasLayer

@onready var _rocketLauncherAnimation = $RocketLauncherReload
@onready var _grenadeLauncherAnimation = $GrenadeLauncherReload
@onready var _grenadeLauncherAmmoText = $GrenadeLauncherReload/Panel/Ammo
@onready var _tileGunSprite = $TileGun
@onready var _tileGunChargesText = $TileGun/Panel/Charges
@onready var _healthBar = $HealthBar
var grenadeLauncherAmmo = 6
var grenadeReloading = false
var grenadeReloadTimer
var tileChargeCount = 3
var tileGunAvail = true
var currWeapon
var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.fired.connect(_on_fired)
	SignalBus.weapon_swap.connect(_on_weapon_swap)
	SignalBus.hurt.connect(_on_hurt)
	_rocketLauncherAnimation.visible = false
	_grenadeLauncherAnimation.visible = false
	_tileGunSprite.visible = false


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
		"Tile":
			if tileGunAvail:
				tileChargeCount -= 1
				_tileGunChargesText.text = str(tileChargeCount)
				if grenadeLauncherAmmo == 0:
					_grenadeLauncherAnimation.play("default")
					tileGunAvail = false

	
func _on_weapon_swap(weaponName):
	currWeapon = weaponName
	match weaponName:
		"Rocket":
			_rocketLauncherAnimation.visible = true
			_grenadeLauncherAnimation.visible = false
			_tileGunSprite.visible = false
		"Grenade":
			_rocketLauncherAnimation.visible = false
			_grenadeLauncherAnimation.visible = true
			_tileGunSprite.visible = false
			_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)
		"Tile":
			_rocketLauncherAnimation.visible = false
			_grenadeLauncherAnimation.visible = false
			_tileGunSprite.visible = true
			_tileGunChargesText.text = str(tileChargeCount)
			
func _on_hurt():
	health -= 1
	_healthBar.frame += 1
	
	
