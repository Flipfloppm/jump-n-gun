extends Control

@onready var rightCharSelect = $HBoxContainer/rightCharSelect
@onready var leftCharSelect = $HBoxContainer/leftCharSelect
@onready var charDisplay = $charDisplay
@onready var charName = $HBoxContainer/charName

var charDict = {
	0: ["guy", "res://Art/UI/HUD/Character Heads/GuyHead.png"],
	1: ["dude", "res://Art/UI/HUD/Character Heads/DudeHead.png"],
	2: ["dick", "res://Art/UI/HUD/Character Heads/cheney-head.png"],
	3: ["ron", "res://Art/UI/HUD/Character Heads/ronald-head.png"],
	4: ["bush", "res://Art/UI/HUD/Character Heads/bush-head.png"]
}
var idx
 
# Called when the node enters the scene tree for the first time.
func _ready():
	idx = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_left_char_select_pressed():
	print("left")
	idx -= 1
	if idx == -1:
		idx = 4
	var charDetails = charDict.get(idx)
	charDisplay.texture = load(charDetails[1])
	charName.text = charDetails[0]
	


func _on_right_char_select_pressed():
	print("right")
	idx += 1
	if idx == 5:
		idx = 0
	var charDetails = charDict.get(idx)
	charDisplay.texture = load(charDetails[1])
	charName.text = charDetails[0]
