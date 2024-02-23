extends VBoxContainer

@onready var rightCharSelect = $HBoxContainer/rightCharSelect
@onready var leftCharSelect = $HBoxContainer/leftCharSelect
@onready var charDisplay = $charDisplay
@onready var charName = $HBoxContainer/CharName
# username of the person controlling it
var user: String
var controllerId
var localId

var charDict = {
	0: ["Dwight", "res://Art/UI/HUD/Character Heads/dwight-head.png"],
	1: ["Dick", "res://Art/UI/HUD/Character Heads/cheney-head.png"],
	2: ["Ron", "res://Art/UI/HUD/Character Heads/ronald-head.png"],
	3: ["Bush", "res://Art/UI/HUD/Character Heads/bush-head.png"]
}
var idx
 
# Called when the node enters the scene tree for the first time.
func _ready():
	idx = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controllerId != localId:
		leftCharSelect.visible = false
		rightCharSelect.visible = false
	var charDetails = charDict.get(idx)
	if GameManager.PLAYERS.has(controllerId):
		GameManager.PLAYERS[controllerId]["Character"] = charDetails[0]
		

#localhostId is a stupid name for the player's instance we are running
func setup(username, id, localhostId):
	$UserId.text = "user id: " + str(id)
	user = username
	controllerId = id
	localId = localhostId
	

func _on_left_char_select_pressed():
	left_idx.rpc()
	


func _on_right_char_select_pressed():
	right_idx.rpc()
	

@rpc("any_peer", "call_local")
func left_idx():
	idx -= 1
	if idx == -1:
		idx = 3
	var charDetails = charDict.get(idx)
	charDisplay.texture = load(charDetails[1])
	charName.text = charDetails[0]

@rpc("any_peer", "call_local")
func right_idx():
	idx += 1
	if idx == 4:
		idx = 0
	var charDetails = charDict.get(idx)
	charDisplay.texture = load(charDetails[1])
	charName.text = charDetails[0]
	
