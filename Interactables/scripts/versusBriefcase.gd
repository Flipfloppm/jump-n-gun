extends Area2D
@onready var _animated_sprite = $BriefcaseAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_animated_sprite.play("default")


func _on_body_entered(body):
	for i in GameManager.PLAYERS:
		if body == GameManager.PLAYERS[i]["body"]:
			SignalBus.game_over.emit(GameManager.PLAYERS[i]["name"])
