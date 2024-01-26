@tool
extends Control

@export var world_index: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "World " + str(world_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$Label.text = "World " + str(world_index)



