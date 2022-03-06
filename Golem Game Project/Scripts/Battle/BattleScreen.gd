extends Control

onready var playerOptions = $UIChoices/Options
onready var playerSkills = $UIChoices/PlayerSkills
onready var enemyGraphics = $EnemyGraphics
onready var playerGraphics = $PlayerGraphics
onready var sceneSetup = $SceneSetup
onready var prompt = $PopUpWindows/MarginContainer/Prompt
onready var skillNameNodes = $UI
var playerSelection  = 3
var previousPlayerSelection = null

var enemyFront = {}
var enemyFrontName:String
var enemyBack = {}
var enemyBackName:String
var enemyCount:int

var playerCount:int
var playerFront = {}
var playerFrontName:String
var playerBack={}
var playerBackName:String

var playerInBattle = false
var skillBeingUsed = null

var turnOrder=[]
var currentTurn = 0

enum BATTLESTATE {ENEMYTURN,PLAYERTURN}
var currentBattleState
var waitingForPlayerInput = false
enum SELECTIONSTATE{SKILLS,ENEMY,ALLY}
onready var currentSelectionState=SELECTIONSTATE.SKILLS
###################### BUILDING ENCOUNTER ############################################
func _ready():
	sceneSetup.play("RESET")
	pass # Replace with function body.

func start_encounter(enemyNode):
	
	enemyGraphics.get_node("EnemyBackingFront/EnemyName").text = enemyNode.enemyName
	enemyFront = enemyNode.statBlock.duplicate()
	enemyGraphics.get_node("EnemySpriteFront").load_sprite((enemyFront["frontSprite"]))
	
	enemyCount =1
	if enemyNode.enemyName == "":
		if enemyNode.isElite == true:
			sceneSetup.play("1v1 Elite")
		else:
			sceneSetup.play("1v1")
	else:
		enemyGraphics.get_node("EnemyBackingBack/EnemyName").text = enemyNode.enemyBackName
		enemyBack = enemyNode.statBlockBack.duplicate()
		enemyGraphics.get_node("EnemySpriteBack").load_sprite(enemyBack["frontSprite"])
		enemyCount +=1
		pass
	load_player_golems(enemyCount)
	find_turn_order()
	if currentBattleState == BATTLESTATE.PLAYERTURN:
		player_turn()
	elif currentBattleState == BATTLESTATE.ENEMYTURN:
		enemy_turn()
func load_player_golems(enemiesInBattle = 1):
	playerCount=0
	for i in range (0, enemiesInBattle,1):
		if i == 0 and GlobalPlayer.partyGolems.empty():
			put_player_in_battle()
			playerCount = 1
		elif i == 0 and i <= GlobalPlayer.partyGolems.size()-1:
			playerFrontName =GlobalPlayer.partyGolems[i].keys()[0]
			playerFront = GlobalPlayer.partyGolems[i][playerFrontName].duplicate()
			
			playerGraphics.get_node("PlayerBackingFront/PlayerName").text = playerFrontName
			playerGraphics.get_node("PlayerSpriteFront").load_sprite(playerFront["backSprite"])

			playerCount += 1
		
		elif i == 1 and i <= GlobalPlayer.partyGolems.size()-1:
			playerBackName =GlobalPlayer.partyGolems[i].keys()[0]
			playerBack = GlobalPlayer.partyGolems[i][playerBackName].duplicate()
			
			playerGraphics.get_node("PlayerBackingBack/PlayerName").text = playerBackName
			playerGraphics.get_node("PlayerSpriteBack").load_sprite(playerBack["backSprite"])
			playerCount += 1
		else:
			## 1 v 2
			lose_1_player()
		
	pass
	
############################### BATTLE MECHANICS ##########################################
func lose_1_player():
	sceneSetup.play("Lose1Player")
	
func put_player_in_battle():
	playerGraphics.get_node("PlayerBackingFront/PlayerName").text = GlobalPlayer.playerName
	playerInBattle = true
	### add more functions
	pass
func find_turn_order():
	turnOrder.clear()
	var playerSpeed
	var enemySpeed
	if playerInBattle:
		playerSpeed= GlobalPlayer.PLAYERSTATS["SPEED"]*.85/2
		turnOrder.append([GlobalPlayer.playerName,GlobalPlayer.PLAYERSTATS])
		
	else:
		var S1 = 0
		var S2 = 0
		for i in playerCount:
			if i == 1:
				S1 = playerFront["SPEED"]
				turnOrder.append([playerFrontName,playerFront])
			elif i == 2:
				S2 = playerBack["SPEED"]
				
		playerSpeed = (S1+S2)*.85/2
	var S1 = 0
	var S2 = 0
	
	for i in enemyCount:
		if i == 1:
			S1 = enemyFront["SPEED"]
		elif i == 2:
			S2 = enemyBack["SPEED"]
	enemySpeed= (S1+S2)*.85/2
	if enemySpeed > playerSpeed:
		currentBattleState = BATTLESTATE.ENEMYTURN
		
		turnOrder.append([enemyFrontName,enemyFront])
		turnOrder.append([playerFrontName,playerFront])
		if enemyCount > 1:
			turnOrder.append([enemyBackName,enemyBack])
		elif enemyCount < playerCount:
			turnOrder.append([enemyFrontName,enemyFront])
		if playerCount >1:
			turnOrder.append([playerBackName,playerBack])
		elif playerCount <enemyCount:
			turnOrder.append([playerFrontName,playerFront])
			
	else:
		currentBattleState = BATTLESTATE.PLAYERTURN
		
		turnOrder.append([playerFrontName,playerFront])
		turnOrder.append([enemyFrontName,enemyFront])

		if playerCount >1:
			turnOrder.append([playerBackName,playerBack])
		elif playerCount <enemyCount:
			turnOrder.append([playerFrontName,playerFront])
		if enemyCount > 1:
			turnOrder.append([enemyBackName,enemyBack])
		elif enemyCount < playerCount:
			turnOrder.append([enemyFrontName,enemyFront])
	print(currentBattleState)
func player_turn():
	var textNode = prompt.get_node("PromptText") 
	textNode.text = "What will you do?"
	var tween = prompt.get_node("PromptTween")
	tween.interpolate_property(textNode,"percent_visibe",0.0,1.0,5,Tween.TRANS_LINEAR)
	tween.start()
	if playerInBattle:
		update_skills(GlobalPlayer.PLAYERSTATS)
	waitingForPlayerInput = true
	pass

func enemy_turn():
	var textNode = prompt.get_node("PromptText") 
	textNode.text = "Void X is about to [attack] [Golem1/G2]! Void Y is [supporting]! What will you do?"
	var tween = prompt.get_node("PromptTween")
	tween.interpolate_property(textNode,"percent_visibe",0.0,1.0,5,Tween.TRANS_LINEAR)
	tween.start()
	waitingForPlayerInput = true
	
	pass
func update_skills(golem):
	var skills = golem["SKILLS"]
	for i in range (1,5,1):
		skillNameNodes.get_node("VBoxContainer/SkillChoice"+str(i)).set_skill(skills["SKILL"+str(i)])
	pass

func select_skill(skillChoice:int): 
	if skillChoice > 4 or skillChoice <0:
		ERR_INVALID_DATA
	var skillDetails = skillNameNodes.get_node("VBoxContainer/SkillChoice"+str(skillChoice)).skillDetails
	if skillDetails["TARGET"] == StatBlocks.TARGET.SELF:
		use_skill(StatBlocks.TARGET.SELF)
	elif skillDetails["TARGET"] == StatBlocks.TARGET.ENEMY:
		currentSelectionState = SELECTIONSTATE.ENEMY
		update_cursor_location_on_current_SELECTIONSTATE()
	elif skillDetails["TARGET"] == StatBlocks.TARGET.ALLY:
		currentSelectionState = SELECTIONSTATE.ALLY
		update_cursor_location_on_current_SELECTIONSTATE()
	return skillDetails
		
func dmg(skillUsed,target):
	
#	var Damage  = Attack/Defense * Base damage * CoreMultiplier * CompostionMultiplier * Level * Affinity * Randomizer * EnvironmentalMultiplier
	pass
func use_skill(target):
	dmg(skillBeingUsed,target)
	
	skillBeingUsed = null
	pass
################################ UI NAVIGATION ##############################################

## Skills and menu coices are 1-6
## Enemies are 80 and 81
## Player Characters are 90 and 91

func update_player_choice(newChoice):
	if newChoice >=1 and newChoice <= 2:
		var newOption = newChoice-1
		playerSkills.get_child(newOption).modulate.a = 1
	elif newChoice >= 3 and newChoice<=6:
		var newOption = newChoice-3
		playerOptions.get_child(newOption).modulate.a = 1
	elif newChoice ==80:
		enemyGraphics.get_node("EnemySpriteFront").cursor_visible(true)
		enemyGraphics.get_node("EnemyBackingFront/PlayerSelection").modulate.a = 1
	elif newChoice ==81:
		enemyGraphics.get_node("EnemySpriteBack").cursor_visible(true)
		enemyGraphics.get_node("EnemyBackingBack/PlayerSelection").modulate.a = 1
	elif newChoice ==90:
		playerGraphics.get_node("PlayerSpriteFront").cursor_visible(true)
		playerGraphics.get_node("PlayerBackingFront/PlayerSelection").modulate.a = 1
	elif newChoice ==91:
		playerGraphics.get_node("PlayerSpriteBack").cursor_visible(true)
		playerGraphics.get_node("PlayerBackingBack/PlayerSelection").modulate.a = 1
	pass
func clear_player_choice(oldChoice):
	if oldChoice >=1 and oldChoice <= 2:
		var newOption = oldChoice-1
		playerSkills.get_child(newOption).modulate.a = 0
	elif oldChoice >= 3 and oldChoice<=6:
		var newOption = oldChoice-3
		playerOptions.get_child(newOption).modulate.a = 0
	
	elif oldChoice ==80:
		enemyGraphics.get_node("EnemySpriteFront").cursor_visible(false)
		enemyGraphics.get_node("EnemyBackingFront/PlayerSelection").modulate.a = 0
	elif oldChoice ==81:
		enemyGraphics.get_node("EnemySpriteBack").cursor_visible(false)
		enemyGraphics.get_node("EnemyBackingBack/PlayerSelection").modulate.a = 0
	elif oldChoice ==90:
		playerGraphics.get_node("PlayerSpriteFront").cursor_visible(false)
		playerGraphics.get_node("PlayerBackingFront/PlayerSelection").modulate.a = 0
	elif oldChoice ==91:
		playerGraphics.get_node("PlayerSpriteBack").cursor_visible(false)
		playerGraphics.get_node("PlayerBackingBack/PlayerSelection").modulate.a = 0


func update_cursor_location_on_current_SELECTIONSTATE():
	
	clear_player_choice(playerSelection)
	
	if currentSelectionState == SELECTIONSTATE.SKILLS:
		if previousPlayerSelection != null:
			playerSelection = previousPlayerSelection
			previousPlayerSelection = null
		else:playerSelection=3 
	elif currentSelectionState == SELECTIONSTATE.ENEMY:
		playerSelection = 80
		
	elif currentSelectionState == SELECTIONSTATE.ALLY:
		playerSelection = 90
	
	
	update_player_choice(playerSelection)
		
	
func select_player_choice(newChoice):
	
	pass
	
func ui_cancel(arrowKeySelection = false):
	if currentSelectionState != SELECTIONSTATE.SKILLS:
		currentSelectionState = SELECTIONSTATE.SKILLS
		update_cursor_location_on_current_SELECTIONSTATE()
		skillBeingUsed = null
	pass
func move_right():
	clear_player_choice(playerSelection)
	if currentSelectionState == SELECTIONSTATE.SKILLS:
		if playerSelection == 1:
			playerSelection = 2
		elif playerSelection == 2:
			playerSelection = 1
		else: ui_accept(true)
	
	elif currentSelectionState == SELECTIONSTATE.ENEMY:
		if playerSelection == 80:
			playerSelection=81
		elif playerSelection == 81:
			playerSelection=80
	
	elif currentSelectionState == SELECTIONSTATE.ALLY:
		if playerSelection == 90:
			playerSelection=91
		elif playerSelection == 91:
			playerSelection=90
	update_player_choice(playerSelection)
func move_left():
	clear_player_choice(playerSelection)
	
	if currentSelectionState == SELECTIONSTATE.SKILLS:
		if playerSelection == 1:
			playerSelection = 2
		elif playerSelection == 2:
			playerSelection = 1
		else: ui_cancel(true)
		
	elif currentSelectionState == SELECTIONSTATE.ENEMY:
		if playerSelection == 80:
			playerSelection=81
		elif playerSelection == 81:
			playerSelection=80
	
	elif currentSelectionState == SELECTIONSTATE.ALLY:
		if playerSelection == 90:
			playerSelection=91
		elif playerSelection == 91:
			playerSelection=90
	update_player_choice(playerSelection)
	
func move_up():
	clear_player_choice(playerSelection)
	
	if currentSelectionState == SELECTIONSTATE.SKILLS:
		if playerSelection == 1:
			playerSelection = 6
		else: playerSelection -= 1
	
	elif currentSelectionState == SELECTIONSTATE.ENEMY:
		if playerSelection == 80:
			playerSelection=81
		elif playerSelection == 81:
			playerSelection=80
	
	elif currentSelectionState == SELECTIONSTATE.ALLY:
		if playerSelection == 90:
			playerSelection=91
		elif playerSelection == 91:
			playerSelection=90
	update_player_choice(playerSelection)
	
func move_down():
	clear_player_choice(playerSelection)
	
	if currentSelectionState == SELECTIONSTATE.SKILLS:
		if playerSelection == 6:
			playerSelection = 1
		else: playerSelection += 1
	
	elif currentSelectionState == SELECTIONSTATE.ENEMY:
		if playerSelection == 80:
			playerSelection=81
		elif playerSelection == 81:
			playerSelection=80
	
	elif currentSelectionState == SELECTIONSTATE.ALLY:
		if playerSelection == 90:
			playerSelection=91
		elif playerSelection == 91:
			playerSelection=90
	update_player_choice(playerSelection)
	
func ui_accept(arrowKeySelection = false):
	if waitingForPlayerInput:
		if playerSelection >=3 and playerSelection <=6:
			previousPlayerSelection = playerSelection
			skillBeingUsed = select_skill(playerSelection-2) ##needs a number 1-4 to find and select the skill node in question
			
		elif currentSelectionState == SELECTIONSTATE.ENEMY:
			if playerSelection == 80:
				use_skill(enemyFront)
			elif playerSelection == 81:
				use_skill(enemyBack)
			print (playerSelection)
		
		elif currentSelectionState == SELECTIONSTATE.ALLY:
			if playerSelection == 90:
				use_skill(playerFront)
			elif playerSelection == 91:
				use_skill(playerBack)
			print (playerSelection)
			pass
			
	pass
