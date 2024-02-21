extends Area2D

var playerCount: int = 0
@onready var _animated_sprite = $BriefcaseAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_animated_sprite.play("default")


func _on_body_entered(body):
	playerCount += 1
	if playerCount == GameManager.PLAYERS.size():
		print("victory!")


func _on_body_exited(body):
	playerCount -= 1
