extends Control

signal buttonSelectAudio
signal buttonMoveAudio
var TextDict = {
	0:{
		"Left": "Golemancers\n\nA golemancer is one who studies and trains in the art of golemancy, that is, the crafting, design and utilizing of golems. Golemancers achieve this by manifesting spirit through a pure substance, such as a crystal or gem, as well as runic inscription to give it direction and form. It is a study of the coming together of science and the ethereal.",
		"Right": "To start, all elements and materials must be present and properly aligned. Golems can be made from a variety of suitable materials, ranging from wood or iron or even elemental substances such as molten rock or ice."
		},
	1:{ 
		"Left": "Although there are several distinctions between runic, mechanical and elemental golems, their basic concept of construction is the same. Importantly, an inscription, traditionally on parchment paper, detailing the commands given to the golem must be placed within the construct.",
		"Right": "This command scroll is commonly known as a covenant. Once this everything is in place, the core spirit crystal, which must be attuned prior, is then to be activated. A golem only becomes animated once its frame is animated by said spirit. Once active, a golem will function within the limits set by its construct and covenant until its core or covenant is damaged.",
		},
	2:{
		"Left": "Golems are linked to their creators in mysterious ways, and this unique bond is still the subject of study for many. Building a golem requires discipline and wisdom and accuracy.",
		"Right": "Golems by nature are guardians, as their most basic function is to serve and protect their creators. History has recorded how golems have served as guardians in many ways. Some have served as protectors for the elite, royal and noble, while others have been created to carry out menial chores or hard larbour in homes or factories."
		},
	}
	
	
var lorePage = 0
var playerCurrentSelection = 0

onready var leftPage = $LeftPage
onready var rightPage = $RightPage
onready var leftButton = $BookMarginContainer/BookBackground/LorePageTurning/BackButton
onready var rightButton = $BookMarginContainer/BookBackground/LorePageTurning/NextButton

# Called when the node enters the scene tree for the first time.
func _ready():
	update_window()
	pass # Replace with function body.

func move_right():
	playerCurrentSelection += 1
	if playerCurrentSelection > 1:
		playerCurrentSelection = 0
	update_player_selection()
func move_left():
	playerCurrentSelection -= 1
	if playerCurrentSelection < 0:
		playerCurrentSelection = 1
	update_player_selection()
func selected():
	if playerCurrentSelection ==0 and lorePage > 0:
		lorePage -=1
		update_window()
	elif playerCurrentSelection == 1 and lorePage < TextDict.size()-1:
		lorePage +=1
		update_window()
	
	emit_signal("buttonSelectAudio")

func update_player_selection():
	if playerCurrentSelection ==0:
		leftButton.modulate =  Color( 0, 0, 0, 1 ) 
		rightButton.modulate =  Color( 1, 1, 1, 1 ) 
		
	if playerCurrentSelection ==1:
		rightButton.modulate =  Color( 0, 0, 0, 1 )
		leftButton.modulate =  Color( 1, 1, 1, 1 ) 
	
	emit_signal("buttonMoveAudio")
		
func update_window():
	if TextDict.has(lorePage):
		if TextDict[lorePage].has("Left"):
			leftPage.text = TextDict[lorePage]["Left"]
		else: leftPage.text = ""
		if TextDict[lorePage].has("Right"):
			rightPage.text = TextDict[lorePage]["Right"]
		else: rightPage.text = ""

func not_primary():
	lorePage = 0
	playerCurrentSelection = 0
	
