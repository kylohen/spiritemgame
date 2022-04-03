extends Control

	
var partyMember = 0
var playerCurrentSelection = 1
var currentGolem
var hasUpgrade = false
onready var leftPage = $LeftPage
onready var rightPage = $RightPage
onready var leftButton = $BookMarginContainer/BookBackground/LorePageTurning/BackButton
onready var rightButton = $BookMarginContainer/BookBackground/LorePageTurning/NextButton
onready var upgradeButton = $Upgrade
onready var upgradeText = $Upgrade/Label

signal buttonSelectAudio
signal buttonMoveAudio
# Called when the node enters the scene tree for the first time.
func _ready():
	 update_player_selection()

func move_right():
	playerCurrentSelection += 1
	if playerCurrentSelection > 2:
		playerCurrentSelection = 0
	update_player_selection()
	emit_signal("buttonMoveAudio")
func move_left():
	playerCurrentSelection -= 1
	if playerCurrentSelection < 0:
		playerCurrentSelection = 2
	update_player_selection()
	emit_signal("buttonMoveAudio")
func selected():
	var moveThroughList = 0 
	if playerCurrentSelection ==0:
		moveThroughList = -1
	elif playerCurrentSelection == 2:
		moveThroughList = -1
	elif hasUpgrade:
		upgradeButton.emit_signal("pressed")
	if moveThroughList != 0:
		var foundPlayer = false
		var count = 0
		if emptyParty():
			get_parent().move_menu(1)
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
		
	emit_signal("buttonSelectAudio")
		
func update_player_selection():
	print ("Player Selection: ", playerCurrentSelection)
	if playerCurrentSelection ==0:
		leftButton.modulate =  Color( 0, 0, 0, 1 ) 
		rightButton.modulate =  Color( 1, 1, 1, 1 ) 
		upgradeText.modulate =  Color( .25, .25,.25, 1 )

		
	elif playerCurrentSelection ==2:
		rightButton.modulate =  Color( 0, 0, 0, 1 )
		leftButton.modulate =  Color( 1, 1, 1, 1 ) 
		upgradeText.modulate =  Color( .25, .25,.25, 1 )
	
	if hasUpgrade:
		upgradeText.modulate = Color(0.915961, 0.740133, 0.243302,1)

	if playerCurrentSelection == 1:
		leftButton.modulate =  Color( 1, 1, 1, 1 ) 
		rightButton.modulate =  Color( 1, 1, 1, 1 ) 
		if hasUpgrade:
			upgradeText.modulate =  Color( 0, 0, 0, 1 )
		else:
			upgradeText.modulate =  Color( .45, .45,.45, 1 )
			

func not_primary():
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
		rightPage.text += currentGolem["NAME"]+"\n"
		rightPage.text += "Level: "+str(currentGolem["LEVEL"])+"\n\n"
		rightPage.text += "HP: "+str(currentGolem["CURRENT HP"]) + "/" + str(currentGolem["HP"])+"\n"
		rightPage.text += "ACTION: "+str(currentGolem["CURRENT ACTION"]) + "/" + str(currentGolem["ACTION METER"])+"\n"
		rightPage.text += "MAGIC: "+ str(currentGolem["CURRENT MAGIC"]) + "/" + str(currentGolem["MAGIC METER"])+"\n\n"
		rightPage.text += "ATTACK: "+ str(currentGolem["ATTACK"]) +"\n"
		rightPage.text += "DEFENSE: "+ str(currentGolem["DEFENSE"]) +"\n"
		rightPage.text += "MAGIC ATTACK: "+ str(currentGolem["MAGIC ATTACK"]) +"\n"
		rightPage.text += "MAGIC DEFENSE: "+ str(currentGolem["MAGIC DEFENSE"]) +"\n"
		rightPage.text += "SPEED: "+ str(currentGolem["SPEED"]) +"\n"
		rightPage.text += "SPEED: "+ str(currentGolem["SPEED"]) +"\n"
		rightPage.text += "UPGRADE COST: "+ str(currentGolem["UPGRADE COST"]) +"\n"
		partyMember = currentGolem["PARTY POSITION"]
		leftPage.texture = load(currentGolem["frontSprite"])
	check_for_upgrade()
	update_player_selection()
#func _process(delta):
#	if hasUpgrade:
#

func check_for_upgrade():
	if currentGolem != null:
		if GlobalPlayer.partyGolems[currentGolem["PARTY POSITION"]] != null:
			if GlobalPlayer.has_item_and_quantity("Dust",currentGolem["UPGRADE COST"]):
				hasUpgrade = true
				upgradeButton.disabled = false
			else:
				hasUpgrade = false
				upgradeButton.disabled = true
			

func _on_Upgrade_pressed():
	var golemID = currentGolem["PARTY POSITION"]
	GlobalPlayer.use_item("Dust",GlobalPlayer.get_latest_key("Dust"),currentGolem["UPGRADE COST"])
	GlobalPlayer.level_up_golem(golemID)
	load_golem(GlobalPlayer.partyGolems[golemID])
	pass # Replace with function body.


func _on_InventoryChecker_timeout():
	check_for_upgrade()
	pass # Replace with function body.
