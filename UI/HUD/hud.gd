extends CanvasLayer

@onready var _rocketLauncherAnimation = $RocketLauncherReload
@onready var _grenadeLauncherAnimation = $GrenadeLauncherReload
@onready var _tileGunAnimation = $TileGunAnimation
@onready var _grenadeLauncherAmmoText = $GrenadeLauncherReload/Panel/Ammo
@onready var _tileGunChargesText = $TileGunAnimation/Panel/Charges
@onready var _c4Sprite = $C4
@onready var _c4ChargesText = $C4/Panel/Charges
@onready var _healthBar = $HealthBar
@onready var _charHead = $HealthBar/CharacterHead
var grenadeLauncherAmmo = 6
var grenadeReloading = false
var grenadeReloadTimer
var tileChargeCount = 5
var tileGunReloading = false
var c4Avail = true
var c4ChargeCount = 1
var currWeapon
var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.fired.connect(_on_fired)
	SignalBus.weapon_swap.connect(_on_weapon_swap)
	SignalBus.hurt.connect(_on_hurt)
	#SignalBus.tilegun_reset.connect(reset_tilegun)
	SignalBus.reload.connect(_on_reload)
	SignalBus.c4detonated.connect(reset_c4)
	_rocketLauncherAnimation.visible = false
	_grenadeLauncherAnimation.visible = false
	_tileGunAnimation.visible = false
	_c4Sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _grenadeLauncherAnimation.animation_finished and grenadeReloading:
		grenadeReloading = false
		grenadeLauncherAmmo = 6
		_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)
	if _tileGunAnimation.animation_finished and tileGunReloading:
		tileGunReloading = false
		tileChargeCount = 5
		_tileGunChargesText.text = str(tileChargeCount)
		

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
		"Tile":
			tileChargeCount -= 1
			_tileGunChargesText.text = str(tileChargeCount)
			if tileChargeCount == 0:
				_tileGunAnimation.play("default")
				tileGunReloading = true
		"C4":
			if c4Avail:
				c4Avail = false
				c4ChargeCount -= 1
				_c4ChargesText.text = str(c4ChargeCount)

func _on_reload():
	match currWeapon:
		"Grenade":
			_grenadeLauncherAnimation.play("default")
			grenadeReloading = true
		"Tile":
			_tileGunAnimation.play("default")
			tileGunReloading = true

	
func _on_weapon_swap(weaponName):
	currWeapon = weaponName
	match weaponName:
		"Rocket":
			_rocketLauncherAnimation.visible = true
			_grenadeLauncherAnimation.visible = false
			_tileGunAnimation.visible = false
			_c4Sprite.visible = false
		"Grenade":
			_rocketLauncherAnimation.visible = false
			_grenadeLauncherAnimation.visible = true
			_tileGunAnimation.visible = false
			_c4Sprite.visible = false
			_grenadeLauncherAmmoText.text = str(grenadeLauncherAmmo)
		"Tile":
			_rocketLauncherAnimation.visible = false
			_grenadeLauncherAnimation.visible = false
			_tileGunAnimation.visible = true
			_c4Sprite.visible = false
			_tileGunChargesText.text = str(tileChargeCount)
		"C4":
			_rocketLauncherAnimation.visible = false
			_grenadeLauncherAnimation.visible = false
			_tileGunAnimation.visible = false
			_c4Sprite.visible = true
			_c4ChargesText.text = str(c4ChargeCount)


#func reset_tilegun():
	#tileGunReloading = false
	#tileChargeCount = 5
	#_tileGunChargesText.text = str(tileChargeCount)


func reset_c4():
	c4Avail = true
	c4ChargeCount = 1
	_c4ChargesText.text = str(c4ChargeCount)
	

func _on_hurt():
	health -= 1
	_healthBar.frame += 1
	

