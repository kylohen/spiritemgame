extends Control

	
var partyMember = 0
<<<<<<< HEAD
var playerCurrentSelection = 0
=======
var playerCurrentSelection = 1
>>>>>>> Battle
var currentGolem

onready var leftPage = $LeftPage
onready var rightPage = $RightPage
onready var leftButton = $BookMarginContainer/BookBackground/LorePageTurning/BackButton
onready var rightButton = $BookMarginContainer/BookBackground/LorePageTurning/NextButton

# Called when the node enters the scene tree for the first time.
func _ready():
<<<<<<< HEAD
#	load_golem(GlobalPlayer.partyGolems[0])
	pass # Replace with function body.
=======
	 update_player_selection()
>>>>>>> Battle

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
	var moveThroughList = 1
	if playerCurrentSelection ==0:
		moveThroughList = -1
<<<<<<< HEAD
	elif playerCurrentSelection == 1 :
		moveThroughList = 1
	var foundPlayer = false
	var count = 0
=======
#	elif playerCurrentSelection == 1 :
#		moveThroughList = 1
	var foundPlayer = false
	var count = 0
	if emptyParty():
		get_parent().move_menu(1)
>>>>>>> Battle
	while !foundPlayer and count <= (GlobalPlayer.maxGolemParty*2):
		partyMember += moveThroughList
		if partyMember < 0:
			partyMember = GlobalPlayer.partyGolems.size()-1
		elif partyMember > GlobalPlayer.partyGolems.size()-1:
			partyMember = 0
			
		if GlobalPlayer.partyGolems[partyMember] != null:
			load_golem(GlobalPlayer.partyGolems[partyMember])
			foundPlayer = true
		count += 1
		
		
func update_player_selection():
	if playerCurrentSelection ==0:
		leftButton.modulate =  Color( 0, 0, 0, 1 ) 
		rightButton.modulate =  Color( 1, 1, 1, 1 ) 
		
	if playerCurrentSelection ==1:
		rightButton.modulate =  Color( 0, 0, 0, 1 )
		leftButton.modulate =  Color( 1, 1, 1, 1 ) 
		

func not_primary():
<<<<<<< HEAD
#	lorePage = 0
	playerCurrentSelection = 0

func load_golem(NewGolem):
	currentGolem = NewGolem
	rightPage.text += currentGolem["NAME"]+"\n\n"
	rightPage.text += "Level: "+str(currentGolem["LEVEL"])+"\n\n"
	rightPage.text += "HP: "+str(currentGolem["CURRENT HP"]) + "/" + str(currentGolem["HP"])+"\n"
	rightPage.text += "ACTION: "+str(currentGolem["CURRENT ACTION"]) + "/" + str(currentGolem["ACTION METER"])+"\n"
	rightPage.text += "MAGIC: "+ str(currentGolem["CURRENT MAGIC"]) + "/" + str(currentGolem["MAGIC METER"])+"\n\n"
	rightPage.text += "ATTACK: "+ str(currentGolem["ATTACK"]) +"\n"
	rightPage.text += "DEFENSE: "+ str(currentGolem["DEFENSE"]) +"\n"
	rightPage.text += "MAGIC ATTACK: "+ str(currentGolem["MAGIC ATTACK"]) +"\n"
	rightPage.text += "MAGIC DEFENSE: "+ str(currentGolem["MAGIC DEFENSE"]) +"\n"
	rightPage.text += "SPEED: "+ str(currentGolem["SPEED"]) +"\n"
	partyMember = currentGolem["PARTY POSITION"]
	leftPage.texture = load(currentGolem["frontsprite"])
#		"MAGIC ATTACK":1,
#		"MAGIC DEFENSE":1,
#		"SPEED":1,
#		"ASPECT":ELEMENT.Ice,
#		"MODIFIERS":{},
#		"DAMAGE OVER TIME":{},
#		"ACTION METER":1000,
#		"MAGIC METER":1000,
#		"CURRENT ACTION":1000,
#		"CURRENT MAGIC":1000,
#		"AFFINITY":1,
#		"LEVEL":1,
#		"NORMAL LOOT DROP":{
#			"Dust":3,
#		},
#		"RARE LOOT DROP":{
#			"Command Seal":1,
#		},
#		"ATTACK SKILLS":{
#			"SKILL1":3,
#			"SKILL2":2,
#			"SKILL3":null,
#			"SKILL4":null,
#			},
#		"SUPPORT SKILLS":{
#			"SKILL1":4,
#			"SKILL2":6,
#			"SKILL3":null,
#			"SKILL4":null,
#			},
#		"DEFEND SKILLS":{
#			"SKILL1":null,
#			"SKILL2":7,
#			"SKILL3":null,
#			"SKILL4":null,
#			},
#		},
=======
#    lorePage = 0
	playerCurrentSelection = 1
func emptyParty():
	for i in GlobalPlayer.partyGolems.size():
		if GlobalPlayer.partyGolems[i] != null:
			return false
	return true
func load_golem(NewGolem):
	currentGolem = NewGolem
	rightPage.text = ""
	if NewGolem == null:
		selected()
	else:
		rightPage.text += currentGolem["NAME"]+"\n\n"
		rightPage.text += "Level: "+str(currentGolem["LEVEL"])+"\n\n"
		rightPage.text += "HP: "+str(currentGolem["CURRENT HP"]) + "/" + str(currentGolem["HP"])+"\n"
		rightPage.text += "ACTION: "+str(currentGolem["CURRENT ACTION"]) + "/" + str(currentGolem["ACTION METER"])+"\n"
		rightPage.text += "MAGIC: "+ str(currentGolem["CURRENT MAGIC"]) + "/" + str(currentGolem["MAGIC METER"])+"\n\n"
		rightPage.text += "ATTACK: "+ str(currentGolem["ATTACK"]) +"\n"
		rightPage.text += "DEFENSE: "+ str(currentGolem["DEFENSE"]) +"\n"
		rightPage.text += "MAGIC ATTACK: "+ str(currentGolem["MAGIC ATTACK"]) +"\n"
		rightPage.text += "MAGIC DEFENSE: "+ str(currentGolem["MAGIC DEFENSE"]) +"\n"
		rightPage.text += "SPEED: "+ str(currentGolem["SPEED"]) +"\n"
		partyMember = currentGolem["PARTY POSITION"]
		leftPage.texture = load(currentGolem["frontSprite"])
#        "MAGIC ATTACK":1,
#        "MAGIC DEFENSE":1,
#        "SPEED":1,
#        "ASPECT":ELEMENT.Ice,
#        "MODIFIERS":{},
#        "DAMAGE OVER TIME":{},
#        "ACTION METER":1000,
#        "MAGIC METER":1000,
#        "CURRENT ACTION":1000,
#        "CURRENT MAGIC":1000,
#        "AFFINITY":1,
#        "LEVEL":1,
#        "NORMAL LOOT DROP":{
#            "Dust":3,
#        },
#        "RARE LOOT DROP":{
#            "Command Seal":1,
#        },
#        "ATTACK SKILLS":{
#            "SKILL1":3,
#            "SKILL2":2,
#            "SKILL3":null,
#            "SKILL4":null,
#            },
>>>>>>> Battle
