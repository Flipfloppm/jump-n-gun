extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var pos = get_node("../Player").global_position # Subtract here if we want to put a info bar at the top.
	var pos = get_parent().global_position
	var x = floor(pos.x / 512) * 512
	var y = floor(pos.y / 288) * 288
	global_position = Vector2(x,y)
