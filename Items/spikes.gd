extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	print(area.get_parent().to_string())
	print(area.get_parent().get_groups())
	if area.get_parent().is_in_group("players"):
		area.get_parent().die()


