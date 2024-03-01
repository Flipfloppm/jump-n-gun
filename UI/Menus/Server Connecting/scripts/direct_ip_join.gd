extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_join_btn_pressed():
	var selected_ip = $CanvasLayer/VBoxContainer/ServerAddressEdit.text
	# TODO: check if IP is valid
	SignalBus.serverBrowserJoin.emit(selected_ip)
	# make this scene invisible
	$CanvasLayer.visible = false
	


func _on_cancel_btn_pressed():
	# clear the input IP
	$CanvasLayer/VBoxContainer/ServerAddressEdit.text = ""
	# make this scene invisible
	$CanvasLayer.visible = false
