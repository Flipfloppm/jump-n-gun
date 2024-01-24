extends Area2D
@onready var _animated_sprite = $Explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	var min_force = 200
	var max_force = 600
	var blast_radius = 100
	get_tree().call_group("players", "on_explosion", position, min_force, max_force, blast_radius)
	# after a second, delete the explosion node
	await get_tree().create_timer(1.0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_animated_sprite.play("default")
