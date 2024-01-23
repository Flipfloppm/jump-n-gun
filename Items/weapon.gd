extends Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.picked_up.connect(_on_rocket_launcher_picked_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	SignalBus.weapon_entered.emit(self, body)

func _on_rocket_launcher_picked_up(rocketBody):
	if rocketBody != self:
		return
	queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
