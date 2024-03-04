extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ice")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Make players slippery
func _on_body_entered(body):
	if body.has_method("change_physics"):
		body.change_physics("ice")


# Return players to regular physics
func _on_body_exited(body):
	if body.has_method("change_physics"):
		body.change_physics("regular")
