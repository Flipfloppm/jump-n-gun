extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _on_body_entered(body):
	#print("pistol entered")
	#hide()
	#pickedUp.emit()
	#$CollisionShape2D.set_deferred("disabled", true)


func _on_player_picked_up():
	queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
