extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$"Pre-checkpoint flag".visible = true
	#$"Post-checkpoint flag".visible = false
	#SignalBus.checkpoint_passed.connect(change_flag)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_checkpoint_area_body_entered(body):
	##var player_name = body.get_name()
	#print("checkpoint: ", multiplayer.get_unique_id())
	#SignalBus.checkpoint.emit(Vector2(500,-585), multiplayer.get_unique_id())
	##$"Post-checkpoint flag".visible = true
	##$"Pre-checkpoint flag".visible = false


#func change_flag():
	#$"Post-checkpoint flag".visible = true
	#$"Pre-checkpoint flag".visible = false
