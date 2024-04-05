extends VBoxContainer

@onready var rightCharSelect = $HBoxContainer/rightCharSelect
@onready var leftCharSelect = $HBoxContainer/leftCharSelect
@onready var charDisplay = $charDisplay
@onready var charName = $HBoxContainer/CharName
# username of the person controlling it
var user: String
var controllerId
var currChar: String

var charDict = {
	0: ["Dwight", "res://Art/UI/HUD/Character Heads/dwight-head.png"],
	1: ["Dick", "res://Art/UI/HUD/Character Heads/cheney-head.png"],
	2: ["Ron", "res://Art/UI/HUD/Character Heads/ronald-head.png"],
	3: ["Bush", "res://Art/UI/HUD/Character Heads/bush-head.png"]
}

var charToIdx = {
	"Dwight": 0,
	"Dick": 1,
	"Ron": 2,
	"Bush": 3
}

var idx
 
# Called when the node enters the scene tree for the first time.
func _ready():
	idx = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controllerId != multiplayer.get_unique_id():
		leftCharSelect.visible = false
		rightCharSelect.visible = false
	var charDetails = charDict.get(idx)
	charDisplay.texture = load(charDetails[1])
	charName.text = charDetails[0]
	currChar = charDetails[0]
	updateChars.rpc()
	
	

#localhostId is a stupid name for the player's instance we are running
func setup(username, id):
	$UserId.text = username
	user = username
	controllerId = id

func setChar(character):
	idx = charToIdx[character]
	var charDetails = charDict.get(idx)
	charDisplay.texture = load(charDetails[1])
	charName.text = charDetails[0]
	

func _on_left_char_select_pressed():
	left_idx.rpc()
	


func _on_right_char_select_pressed():
	right_idx.rpc()
	

@rpc("any_peer", "call_local","reliable",1)
func left_idx():
	idx -= 1
	if idx == -1:
		idx = 3
	

@rpc("any_peer","call_local","reliable",1)
func right_idx():
	idx += 1
	if idx == 4:
		idx = 0
	
	

@rpc("any_peer", "call_local","reliable")
func updateChars():
	if GameManager.PLAYERS.has(controllerId):
		GameManager.PLAYERS[controllerId]["Character"] = currChar
	
