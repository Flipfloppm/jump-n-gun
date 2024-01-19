extends Area2D
#@export var player :PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("explode")
	var min_force = 200
	var max_force = 600
	var blast_radius = 100
	get_tree().call_group("players", "on_explosion", position, min_force, max_force, blast_radius)
	
	#var player = load("res://Characters/player.tscn")
	#var player_instance = player.instantiate()
	#explode.connect(player_instance._on_explosion)
	#print(explode.get_connections())
	#print(explode.is_connected(player_instance._on_explosion))
	
	await get_tree().create_timer(1.0).timeout
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
