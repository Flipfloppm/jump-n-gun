extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

# FOR MULTIPLAYER LEVELS (Individuals dying)
func _on_body_entered(body):
	#print("ENTERED SPIKES")
	if body.has_method("die"):
		#print("DIE TRUE")
		get_tree().reload_current_scene();