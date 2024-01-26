extends RigidBody2D

var direction : Vector2
var explosion = preload("res://Items/explosion.tscn")
var collision_info
# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(1,0).rotated(rotation) * linear_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity.x *= 0.7
		linear_velocity.y *= 0.5


func _on_timer_timeout():
	var e = explosion.instantiate()
	e.global_position = get_position()
	get_tree().root.add_child(e)
	queue_free()
