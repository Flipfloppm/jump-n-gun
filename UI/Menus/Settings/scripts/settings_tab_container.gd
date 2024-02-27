extends Control
var current_button
@onready var vBox = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer
@onready var leftBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/HBoxContainer/left
@onready var rightBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer2/HBoxContainer/right
@onready var jumpBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer3/HBoxContainer/jump
@onready var shootBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer4/HBoxContainer/shoot
@onready var selectRLBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer5/HBoxContainer/selectRocketLauncher
@onready var selectGLBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer6/HBoxContainer/selectGrenadeLauncher
@onready var restartBtn = $TabContainer/Controls/MarginContainer/ScrollContainer/VBoxContainer/MarginContainer7/HBoxContainer/Restart
var btnArr 

# Called when the node enters the scene tree for the first time.
func _ready():
	btnArr = [leftBtn, rightBtn, jumpBtn, shootBtn, selectRLBtn, selectGLBtn, restartBtn]
	bindButtons()
	for button in btnArr:
		_update_labels(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed(button: Button):
	current_button = button
	$InputPopUp.visible = true
	
func _input(event: InputEvent):
	if !current_button: # return if current_button is null
		return
	if event is InputEventKey || event is InputEventMouseButton:
		# This part is for deleting duplicate assignments:
		# Add all assigned keys to a dictionary
		var all_ies : Dictionary = {}
		for ia in InputMap.get_actions():
			for iae in InputMap.action_get_events(ia):
				all_ies[iae.as_text()] = ia
		
		# check if the new key is already in the dict.
		# If yes, delete the old one.
		if all_ies.keys().has(event.as_text()):
			InputMap.action_erase_events(all_ies[event.as_text()])
		
		# This part is where the actual remapping occures:
		# Erase the event in the Input map
		InputMap.action_erase_events(current_button.name)
		# And assign the new event to it
		InputMap.action_add_event(current_button.name, event)
		
		$InputPopUp.visible = false # hide the info panel again
		_update_labels(current_button)
		current_button = null
		
		

func _update_labels(button) -> void:
	# This is just a quick way to update the labels:
	var eb1 : Array[InputEvent] = InputMap.action_get_events(button.name)
	if !eb1.is_empty():
		button.text = eb1[0].as_text()
	else:
		button.text = ""

func bindButtons():
	for button in btnArr:
		print(button)
		button.pressed.connect(_on_button_pressed.bind(button))
