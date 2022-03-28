extends Control

onready var playerOptions = $UIChoices/Options
onready var playerSkills = $UIChoices/PlayerSkills
onready var enemyGraphics = $EnemyGraphics
onready var playerGraphics = $PlayerGraphics
onready var sceneSetup = $SceneSetup
onready var prompt = $PopUpWindows/MarginContainer/Prompt
onready var skillNameNodes = $UI
onready var playerFrontUIBar= $PlayerGraphics/PlayerBackingFront/UI_Bars
onready var playerBackUIBar= $PlayerGraphics/PlayerBackingBack/UI_Bars
onready var enemyFrontUIBar= $EnemyGraphics/EnemyBackingFront/UI_Bars
onready var enemyBackUIBar= $EnemyGraphics/EnemyBackingBack/UI_Bars
onready var battleWinScreen = $PopUpWindows/BattleWin
onready var sceneLoadInAndOut = $SceneLoadInAndOut

enum MENU{ATTACK,SUPPORT,DEFEND,FLEE, ITEM,PARTY, NONE, WIN}
enum {REST,ATTACK,HIT,SUPPORT,DEFEND,FLEE,DEATH, SENDOUT,SENDIN}
var currentMenu = MENU.NONE
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
var selectedGolem = {}
var allyGolemFrontChosen = false
var allyGolemBackChosen = null

var pendingSkills = [] #self
var AllyGolems = []
var AllyGolemsSkillUsed = []
var EnemyGolems = []
var modifers = [{},{},{},{}]
var selectableSkillOptions = []

enum BATTLESTATE {ENEMYTURN,PLAYERTURN}
var currentBattleState
var waitingForPlayerInput = false
enum SELECTIONSTATE{SKILLS,ENEMY,ALLY, BOTH, SECONDARY,MAIN}
onready var currentSelectionState=SELECTIONSTATE.MAIN

var lootToWin = []
enum SPECIALKILL {OVERKILL,EXACTKILL,LINKKILL,DEBUFFKILL,FIREKILL,WATERKILL,LIGHTKILL,DARKKILL}
var playerUsedSupport = false

var voidChanceToRun =0.25 #25% chance void will run away with Core
var lootModifier = 1
var battleWon = false
var partyChoice = 0
var golemSwitch = null
onready var maxParty = GlobalPlayer.maxGolemParty


var itemChoice = 0
var listOfUseableItems =[]
var itemUsed = null
###################### BUILDING ENCOUNTER ############################################
func _ready():
	sceneSetup.play("RESET")
	
	pass # Replace with function body.

func start_encounter(enemyNode):
	load_enemy_golems(enemyNode)
	load_player_golems(EnemyGolems.size())
	find_turn_order()
	if currentBattleState == BATTLESTATE.PLAYERTURN:
		player_turn()
	elif currentBattleState == BATTLESTATE.ENEMYTURN:
		enemy_turn()
	ui_main_menu_update()

##Sets the stage on initialization and pulls golems in from your party Roster, taking the first two
func load_player_golems(enemiesInBattle = 1):
	playerCount=0
	for i in range (0, enemiesInBattle,1):
		if i == 0 and GlobalPlayer.partyGolems.empty():
			put_player_in_battle()
			playerCount = 1
			playerFront = GlobalPlayer.PLAYERSTATS
			playerFrontName = GlobalPlayer.playerName
			
			initialize_ui_bars(GlobalPlayer.PLAYERSTATS,playerFrontUIBar)
			playerFront["NODE"] = playerGraphics.get_node("PlayerSpriteFront")
			playerFront["UI NODE"] = playerFrontUIBar
			AllyGolems.append(playerFront)
			AllyGolemsSkillUsed.append(false)
		elif i == 0 and i <= GlobalPlayer.partyGolems.size()-1:
#			playerFrontName =GlobalPlayer.partyGolems[i]["NAME"]
#			playerFront = GlobalPlayer.partyGolems[i].duplicate()
#
#			playerGraphics.get_node("PlayerBackingFront/PlayerName").text = playerFrontName
#			playerGraphics.get_node("PlayerSpriteFront").load_sprite(playerFront["backSprite"])

			
#			initialize_ui_bars(playerFront,playerFrontUIBar)
#			playerFront["NODE"] = playerGraphics.get_node("PlayerSpriteFront")
#			playerFront["UI NODE"] = playerFrontUIBar
			load_front_player(GlobalPlayer.partyGolems[i].duplicate())
			AllyGolems.append(playerFront)
			AllyGolemsSkillUsed.append(false)
			playerCount += 1
			
		elif i == 1 and i <= GlobalPlayer.partyGolems.size()-1:
			load_back_player(GlobalPlayer.partyGolems[i].duplicate())
#			playerBackName =GlobalPlayer.partyGolems[i]["NAME"]
#			playerBack = GlobalPlayer.partyGolems[i].duplicate()
#
#			playerGraphics.get_node("PlayerBackingBack/PlayerName").text = playerBackName
#			playerGraphics.get_node("PlayerSpriteBack").load_sprite(playerBack["backSprite"])
#			playerCount += 1
#			initialize_ui_bars(playerBack,playerBackUIBar)
#			playerBack["NODE"] = playerGraphics.get_node("PlayerSpriteBack")
#			playerBack["UI NODE"] = playerBackUIBar
#			AllyGolems.append(playerBack)
#			AllyGolemsSkillUsed.append(false)
			playerCount += 1
		else:
			## 1 v 2
			lose_1_player()
		selectedGolem = AllyGolems[0]
func load_back_player(playerDict):
	playerBackName = playerDict["NAME"]
	playerBack = playerDict
	playerGraphics.get_node("PlayerBackingBack/PlayerName").text = playerBackName
	playerGraphics.get_node("PlayerSpriteBack").load_sprite(playerBack["backSprite"])
	
	initialize_ui_bars(playerBack,playerBackUIBar)
	playerBack["NODE"] = playerGraphics.get_node("PlayerSpriteBack")
	playerBack["UI NODE"] = playerBackUIBar
	if AllyGolems.size()>= 1:
		AllyGolems.remove(1)
		AllyGolemsSkillUsed.remove(1)
	
	AllyGolems.append(playerBack)
	AllyGolemsSkillUsed.append(false)
	
	
	pass
	
func load_enemy_golems(enemyNode):
	
	load_front_enemy(enemyNode.statBlock.duplicate())
#	enemyGraphics.get_node("EnemyBackingFront/EnemyName").text = enemyNode.enemyName
#	enemyFront = enemyNode.statBlock.duplicate()
#	enemyGraphics.get_node("EnemySpriteFront").load_sprite((enemyFront["frontSprite"]))
#	enemyCount =1
#	enemyFrontName = enemyNode.enemyName
##	update_health_bars(enemyFront,enemyFrontUIBar)
##	update_ui_aspect(enemyFront,enemyFrontUIBar)
#
#	initialize_ui_bars(enemyFront,enemyFrontUIBar)
#	enemyFront["NODE"] = enemyGraphics.get_node("EnemySpriteFront")
#	enemyFront["UI NODE"] = enemyFrontUIBar
	EnemyGolems.append(enemyFront)
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
		enemyBackName = enemyNode.enemyBackName
#		update_health_bars(enemyBack,enemyBackUIBar)
#		update_ui_aspect(enemyBack,enemyBackUIBar)
		initialize_ui_bars(enemyBack,enemyBackUIBar)
		enemyBack["NODE"] = enemyGraphics.get_node("EnemySpriteBack")
		enemyBack["UI NODE"] = enemyBackUIBar
		EnemyGolems.append(enemyBack)
		pass
func load_front_enemy(enemyDict):
	enemyGraphics.get_node("EnemyBackingFront/EnemyName").text = enemyDict["NAME"]
	enemyFront = enemyDict
	enemyGraphics.get_node("EnemySpriteFront").load_sprite((enemyFront["frontSprite"]))
	
	enemyFrontName = enemyDict["NAME"]
	initialize_ui_bars(enemyFront,enemyFrontUIBar)
	enemyFront["NODE"] = enemyGraphics.get_node("EnemySpriteFront")
	enemyFront["UI NODE"] = enemyFrontUIBar
func load_front_player(playerDict):
	
	playerFrontName = playerDict["NAME"]
	playerFront = playerDict
	playerGraphics.get_node("PlayerBackingFront/PlayerName").text = playerFrontName
	playerGraphics.get_node("PlayerSpriteFront").load_sprite(playerFront["backSprite"])
	
	initialize_ui_bars(playerFront,playerFrontUIBar)
	playerFront["NODE"] = playerGraphics.get_node("PlayerSpriteFront")
	playerFront["UI NODE"] = playerFrontUIBar
	if !AllyGolems.empty():
		AllyGolems.remove(0)
		AllyGolemsSkillUsed.remove(0)
	
	AllyGolems.insert(0,playerFront)
	AllyGolemsSkillUsed.insert(0,false)
	
func initialize_ui_bars(stats,locationOfUI):
#	initialize(health,healthMax,action,actionMax,magic,magicMax)
	locationOfUI.initialize(stats["CURRENT HP"],stats["HP"], stats["CURRENT ACTION"], stats["ACTION METER"], stats["CURRENT MAGIC"], stats["MAGIC METER"])
	locationOfUI.update_aspect(stats["ASPECT"])
	pass
func update_health_bars(stats,locationOfUI):
	locationOfUI.update_ui_health_bar(stats["CURRENT HP"],stats["HP"])
func update_ui_aspect(stats,locationOfUI):
	locationOfUI.update_aspect(stats["ASPECT"])

func find_turn_order():
	turnOrder.clear()
	var playerSpeed
	var enemySpeed
	if playerInBattle:
		playerSpeed= GlobalPlayer.PLAYERSTATS["SPEED"]*.85/2
		turnOrder.append([GlobalPlayer.playerName,GlobalPlayer.PLAYERSTATS])
		
	else:
		var speedValues = 0
		for i in AllyGolems.size():
			speedValues += AllyGolems[i]["SPEED"]
			
		playerSpeed = (speedValues)*.85/2
	var speedValues = 0
	
	for i in EnemyGolems.size():
		speedValues += EnemyGolems[i]["SPEED"]
	enemySpeed= (speedValues)*.85/2
	if enemySpeed > playerSpeed:
		currentBattleState = BATTLESTATE.ENEMYTURN
#
#		turnOrder.append([enemyFrontName,enemyFront])
#		turnOrder.append([playerFrontName,playerFront])
#		if enemyCount > 1:
#			turnOrder.append([enemyBackName,enemyBack])
#		elif enemyCount < playerCount:
#			turnOrder.append([enemyFrontName,enemyFront])
#		if playerCount >1:
#			turnOrder.append([playerBackName,playerBack])
#		elif playerCount <enemyCount:
#			turnOrder.append([playerFrontName,playerFront])
			
	else:
		currentBattleState = BATTLESTATE.PLAYERTURN
#



############################### BATTLE MECHANICS ##########################################
func lose_1_player():
	sceneSetup.play("Lose1Player")

func lose_1_enemy():
	sceneSetup.play("Lose1Enemy")
	
func put_player_in_battle():
	playerGraphics.get_node("PlayerBackingFront/PlayerName").text = GlobalPlayer.playerName
	playerInBattle = true
	### add more functions
	pass
func player_turn():
	var textNode = prompt.get_node("PromptText") 
	textNode.rect_scale = Vector2(.5,.5)
	textNode.text = ""
	textNode.text = "What will you do?"
	var tween = prompt.get_node("PromptTween")
	tween.interpolate_property(textNode,"percent_visible",0.0,1.0,2,Tween.TRANS_LINEAR)
	tween.start()
	selectedGolem = AllyGolems[0]
	update_UI_selected_Ally_Golem()
	waitingForPlayerInput = true
	pass

func find_golems_attack_and_target(golemDict) ->String :
	for i in pendingSkills.size():
		if pendingSkills[i][0]==golemDict:
			return str(pendingSkills[i][2]["NAME"]) + " on " + str(pendingSkills[i][1]["NAME"])
	return "no skill found"
func enemy_turn():
	decide_enemy_move()
	var textNode = prompt.get_node("PromptText") 
	textNode.rect_scale = Vector2(.5,.5)
	textNode.text = ""
	textNode.text = str(EnemyGolems[0]["NAME"])+" is about to use " + str(find_golems_attack_and_target(EnemyGolems[0])) +"\n"
	
	if EnemyGolems.size() > 1:
		textNode.text += str(EnemyGolems[1]["NAME"]) + "is about to use " + str(find_golems_attack_and_target(EnemyGolems[1])) +"\n"
	textNode.text += "What will you do?"
	var tween = prompt.get_node("PromptTween")
	tween.interpolate_property(textNode,"percent_visible",0.0,1.0,2,Tween.TRANS_LINEAR)
	tween.start()
	selectedGolem = AllyGolems[0]
	update_UI_selected_Ally_Golem()
	waitingForPlayerInput = true
func decide_enemy_move():
	var GolemToAttack = SeedGenerator.rng.randi_range(0,EnemyGolems.size()-1)
	for i in EnemyGolems.size():
#		var skillUsed
		if GolemToAttack == i:
			var golemTarget = AllyGolems[SeedGenerator.rng.randi_range(0,AllyGolems.size())-1]
			if !arrayOfUsableSkills(EnemyGolems[i]["ATTACK SKILLS"]).empty():
				var skillsAvailable = arrayOfUsableSkills(EnemyGolems[i]["ATTACK SKILLS"])
				var rollForSkill= SeedGenerator.rng.randi_range(1,skillsAvailable.size()-1)
				var skillChosen = StatBlocks.skillList[skillsAvailable[rollForSkill]]
				if skillChosen["TARGET"] == StatBlocks.TARGET.SELF:
					golemTarget = EnemyGolems[i]
				else: golemTarget = AllyGolems[SeedGenerator.rng.randi_range(0,AllyGolems.size()-1)]
				store_choice(EnemyGolems[i],golemTarget,skillChosen)
			else:
				if i == 0:
					golemTarget = EnemyGolems[1]
				elif i == 1:
					golemTarget = EnemyGolems[0]
				
				if !arrayOfUsableSkills(EnemyGolems[i]["DEFEND SKILLS"]).empty():
					var skillsAvailable = arrayOfUsableSkills(EnemyGolems[i]["DEFEND SKILLS"])
					var rollForSkill= SeedGenerator.rng.randi_range(1,skillsAvailable.size()-1)
					var skillChosen = StatBlocks.skillList[skillsAvailable[rollForSkill]]
					if skillChosen["TARGET"] == StatBlocks.TARGET.SELF:
						golemTarget = EnemyGolems[i]
					store_choice(EnemyGolems[i],golemTarget,skillChosen)
				
				elif !arrayOfUsableSkills(EnemyGolems[i]["SUPPORT SKILLS"]).empty() :
					var skillsAvailable = arrayOfUsableSkills(EnemyGolems[i]["SUPPORT SKILLS"])
					var rollForSkill= SeedGenerator.rng.randi_range(1,skillsAvailable.size()-1)
					var skillChosen = StatBlocks.skillList[skillsAvailable[rollForSkill]]
					if skillChosen["TARGET"] == StatBlocks.TARGET.SELF:
						golemTarget = EnemyGolems[i]
					store_choice(EnemyGolems[i],golemTarget,skillChosen)
				else:
#					skillUsed = StatBlocks.skillList[0]
#					var skillDetails = StatBlocks.skillList[skillUsed]
					golemTarget = AllyGolems[SeedGenerator.rng.randi_range(0,AllyGolems.size()-1)]
					store_choice(enemyFront,golemTarget,StatBlocks.skillList[0])
		else:
			var golemTarget
			if i == 0:
				golemTarget = EnemyGolems[1]
			elif i == 1:
				golemTarget = EnemyGolems[0]
			if !arrayOfUsableSkills(EnemyGolems[i]["SUPPORT SKILLS"]).empty() :
				var skillsAvailable = arrayOfUsableSkills(EnemyGolems[i]["SUPPORT SKILLS"])
				var rollForSkill= SeedGenerator.rng.randi_range(1,skillsAvailable.size()-1)
				var skillChosen = StatBlocks.skillList[skillsAvailable[rollForSkill]]
				if skillChosen["TARGET"] == StatBlocks.TARGET.SELF:
					golemTarget = EnemyGolems[i]
				store_choice(EnemyGolems[i],golemTarget,skillChosen)
			elif !arrayOfUsableSkills(EnemyGolems[i]["DEFEND SKILLS"]).empty():
				var skillsAvailable = arrayOfUsableSkills(EnemyGolems[i]["DEFEND SKILLS"])
				var rollForSkill= SeedGenerator.rng.randi_range(1,skillsAvailable.size()-1)
				var skillChosen = StatBlocks.skillList[skillsAvailable[rollForSkill]]
				if skillChosen["TARGET"] == StatBlocks.TARGET.SELF:
					golemTarget = EnemyGolems[i]
				store_choice(EnemyGolems[i],golemTarget,skillChosen)
			elif !arrayOfUsableSkills(EnemyGolems[i]["ATTACK SKILLS"]).empty():
				var skillsAvailable = arrayOfUsableSkills(EnemyGolems[i]["ATTACK SKILLS"])
				var rollForSkill= SeedGenerator.rng.randi_range(1,skillsAvailable.size()-1)
				var skillChosen = StatBlocks.skillList[skillsAvailable[rollForSkill]]
				if skillChosen["TARGET"] == StatBlocks.TARGET.SELF:
					golemTarget = EnemyGolems[i]
				else: golemTarget = AllyGolems[SeedGenerator.rng.randi_range(1,AllyGolems.size())]
				store_choice(EnemyGolems[i],golemTarget,skillChosen)
			else:
#				skillUsed = StatBlocks.skillList[0]
#				var skillDetails = StatBlocks.skillList[skillUsed]
				
				golemTarget = AllyGolems[SeedGenerator.rng.randi_range(1,AllyGolems.size())]
				store_choice(enemyFront,golemTarget,StatBlocks.skillList[0])
		
	pass
func arrayOfUsableSkills (dictOfSkills):
	var arrayOfViable = []
	if dictOfSkills != null and !dictOfSkills.empty():
		var keys = dictOfSkills.keys()
		for i in keys.size():
			if dictOfSkills[keys[i]] != null:
				arrayOfViable.append(dictOfSkills[keys[i]])
	return arrayOfViable
func update_skills(golem,menu):
	var skillType
	var selectableSkills = []
	if menu == MENU.ATTACK:
		skillType = "ATTACK SKILLS"
	elif menu == MENU.SUPPORT:
		skillType = "SUPPORT SKILLS"
	elif menu == MENU.DEFEND:
		skillType = "DEFEND SKILLS"
	elif menu == MENU.FLEE:
		skillBeingUsed = StatBlocks.skillList[1]
		use_skill(golem)
		return
	var skills = golem[skillType]
	for i in range (1,5,1):
		var isSelectable = true
		skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i)).set_skill(skills["SKILL"+str(i)])
		if !check_skill_cost (golem,skills["SKILL"+str(i)]):
			skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i)).not_enough_energy()
			isSelectable = false
		selectableSkills.append(isSelectable)
	selectableSkillOptions = selectableSkills


func update_secondary(golem,menu):
	var skillType
	var selectableSkills = []
	if menu == MENU.ITEM:
		currentMenu = MENU.ITEM
		update_item_list()
	elif menu == MENU.PARTY:
		currentMenu = MENU.PARTY
		partyChoice = 0
		update_golem_list()
	elif menu == MENU.FLEE:
		currentMenu = MENU.FLEE
		skillBeingUsed = StatBlocks.skillList[1]
		use_skill(null)
	
func update_golem_list(firstGolemOnList = 0):
	var selectableSkills = []
	
	var listOfPartyMembers = GlobalPlayer.partyGolems
	var golemDisplay = firstGolemOnList
		
	for i in 4:
		if golemDisplay > maxParty-1:
			golemDisplay = 0
		if golemDisplay< 0:
			golemDisplay += maxParty
		var foundMatch = false
#		print (listOfPartyMembers.size()," < ",i,int(listOfPartyMembers.size()) < int(i))
		if listOfPartyMembers.size() <= golemDisplay:
			skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i+1)).set_golem(null,false)
			selectableSkills.append(false)
			foundMatch = true
		
		elif golemSwitch != null :
			if  listOfPartyMembers[golemDisplay]["PARTY POSITION"] == golemSwitch["PARTY POSITION"] :  ###Removes the ability of selecting the same golem twice
				skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i+1)).set_golem(listOfPartyMembers[golemDisplay],false)
				selectableSkills.append(false)
				foundMatch = true
			
		if !foundMatch:
			for j in AllyGolems.size():
				
				if  listOfPartyMembers[golemDisplay]["PARTY POSITION"] == AllyGolems[j]["PARTY POSITION"]:
					skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i+1)).set_golem(listOfPartyMembers[golemDisplay],false)
					selectableSkills.append(false)
					foundMatch = true
		if !foundMatch:
			skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i+1)).set_golem(listOfPartyMembers[golemDisplay],true)
			selectableSkills.append(true)
		golemDisplay += 1
	
	selectableSkillOptions = selectableSkills
#	print (selectableSkillOptions)

func find_usable_items():
	var itemIndex = GlobalPlayer.itemIndexDict
	var itemIndexKeys = itemIndex.keys()
	var itemList = GlobalPlayer.inventoryListDict
	var usable_items = []
	for i in itemIndexKeys.size():
		if LootTable.UseItemList.has(itemIndex[itemIndexKeys[i]]):
			usable_items.append(GlobalPlayer.get_item_and_quantity(itemIndexKeys[i],true))
			
	return usable_items
func update_item_list(firstItemOnList = 0):
	var selectableItems = []
	var itemDisplay = firstItemOnList
	
	listOfUseableItems = find_usable_items()
	if listOfUseableItems.size() < 4:
		while listOfUseableItems.size()<4:
			listOfUseableItems.append([null,null])
	
	for i in 4:
		if itemDisplay > listOfUseableItems.size()-1:
			itemDisplay = 0
		elif itemDisplay< 0:
			itemDisplay += listOfUseableItems.size()
#		
		if listOfUseableItems[itemDisplay] == itemUsed and (listOfUseableItems[itemDisplay][1]-itemUsed[1]) <=0:
			
#			print (listOfUseableItems[itemDisplay][1], " - ", itemUsed[1])
			skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i+1)).set_item(listOfUseableItems[itemDisplay][0],listOfUseableItems[itemDisplay][1],itemDisplay,false)
			selectableItems.append(false)
		else:
			skillNameNodes.get_node("VBoxContainer/MenuItem"+str(i+1)).set_item(listOfUseableItems[itemDisplay][0],listOfUseableItems[itemDisplay][1],itemDisplay)
			if listOfUseableItems[itemDisplay] != [null,null,null]:
				selectableItems.append(true)
			else: selectableItems.append(false)
		itemDisplay += 1
	selectableSkillOptions = selectableItems
	
func check_skill_cost(golem,skillNumber):
	if skillNumber != null:
		if golem["CURRENT ACTION"] >= StatBlocks.skillList[skillNumber]["ACTION METER COST"] and golem["CURRENT MAGIC"] >= StatBlocks.skillList[skillNumber]["MAGIC METER COST"]:
			return true
	return false


func ui_main_menu_update():
	skillNameNodes.get_node("VBoxContainer/MenuItem1").main_menu("Attack")
	skillNameNodes.get_node("VBoxContainer/MenuItem2").main_menu("Support")
	skillNameNodes.get_node("VBoxContainer/MenuItem3").main_menu("Defend")
	skillNameNodes.get_node("VBoxContainer/MenuItem4").main_menu("Flee")
	currentMenu = MENU.NONE
	currentSelectionState = SELECTIONSTATE.MAIN
	pass
func ui_secondary_menu_update():
	skillNameNodes.get_node("VBoxContainer/MenuItem1").side_menu("Item")
	skillNameNodes.get_node("VBoxContainer/MenuItem2").side_menu("Party")
	skillNameNodes.get_node("VBoxContainer/MenuItem3").side_menu("Flee")
	skillNameNodes.get_node("VBoxContainer/MenuItem4").side_menu("None")
	currentMenu = MENU.NONE
	currentSelectionState = SELECTIONSTATE.SECONDARY
#	selectableSkillOptions = [true,true,true,false]
	pass
func select_skill(skillChoice:int): 
	if skillChoice > 4 or skillChoice <0:
		ERR_INVALID_DATA
	var skillDetails = skillNameNodes.get_node("VBoxContainer/MenuItem"+str(skillChoice)).skillDetails
	if skillDetails["TARGET"] == StatBlocks.TARGET.SELF:
		skillBeingUsed = skillDetails
		use_skill(selectedGolem)
	elif skillDetails["TARGET"] == StatBlocks.TARGET.ENEMY:
		currentSelectionState = SELECTIONSTATE.ENEMY
		update_cursor_location_on_current_SELECTIONSTATE()
	elif skillDetails["TARGET"] == StatBlocks.TARGET.ALLY:
		currentSelectionState = SELECTIONSTATE.ALLY
		update_cursor_location_on_current_SELECTIONSTATE()
	return skillDetails

func animate_sprite(nodeToAnimate,TypeOfAnimation):
	nodeToAnimate.animation(TypeOfAnimation)
#	yield(nodeToAnimate,"sprite_animation_done")

func update_ui_action_bars(nodeToUpdate,skillUsedForCost):
	var actionCost = 0
	var magicCost = 0
	if skillUsedForCost.has("ACTION METER COST"):
		actionCost =  skillUsedForCost["ACTION METER COST"]
	if skillUsedForCost.has("MAGIC METER COST"):
		magicCost =  skillUsedForCost["MAGIC METER COST"]
		
	nodeToUpdate.update_ui_action_bars(actionCost,magicCost)
	pass
func update_ui_health_bar(nodeToUpdate,newHP):
	nodeToUpdate.update_ui_health_bar(newHP)

func debug_pendingSkills():
	var string = ""
	for i in pendingSkills.size():
		for j in 3:
			string += pendingSkills[i][j]["NAME"] + ",  "
			if j == 2:
				string += " Type: "+ pendingSkills[i][j]["TYPE"]+"\n"
				
	return string
func check_if_golem_dead(golemInQuestion):
	if AllyGolems.has(golemInQuestion) or EnemyGolems.has(golemInQuestion):
		return false
	return true

	

func sort_by_speed(a, b):
	if typeof(a) == typeof(b):
		var speedModifierA = 1
		var speedModifierB = 1
		if a[0]["MODIFIERS"].has("SPEED"):
			speedModifierA =  a[0]["MODIFIERS"]["SPEED"]
		if b[0]["MODIFIERS"].has("SPEED"):
			speedModifierB =  b[0]["MODIFIERS"]["SPEED"]
		return (a[0]["SPEED"]*speedModifierA)>(b[0]["SPEED"]*speedModifierB)
	else:
		return a > b
func update_combat_text(actionSet):
	prompt.get_node("PromptText").text = actionSet[0]["NAME"]+" uses "+actionSet[2]["NAME"]+" on "+actionSet[1]["NAME"]
	prompt.get_node("PromptTween").interpolate_property(prompt.get_node("PromptText"),"percent_visible",0.0,1.0,1)
	prompt.get_node("PromptTween").start()

func spend_energy(golem,skill):
	golem["CURRENT ACTION"] -= skill["ACTION METER COST"]
	golem["CURRENT MAGIC"] -= skill["MAGIC METER COST"]

func resolve_turn():
	GlobalPlayer.isInAnimation = true
	while !pendingSkills.empty():
#		print (debug_pendingSkills())
		pendingSkills.sort_custom(self,"sort_by_speed")
		for i in range (pendingSkills.size(),0,-1):
			if pendingSkills[i-1][2]["NAME"] == "Flee":
				update_combat_text(pendingSkills[i-1])
				
				animate_sprite(pendingSkills[i-1][0]["NODE"],FLEE)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				var rollForFlee = SeedGenerator.rng.randf_range(0,1)
				var chanceForSuccess = pendingSkills[i-1][0]["SPEED"]/100
				
				if chanceForSuccess>=rollForFlee :
					if EnemyGolems.has(pendingSkills[i-1][0]):
						void_ran_away(pendingSkills[i-1][0])
					else:
						lose_battle()
				
#				animate_sprite(pendingSkills[i-1][0]["NODE"],SENDIN)
#				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				
				pendingSkills.erase(pendingSkills[i-1])
		for i in range (pendingSkills.size(),0,-1):
			if pendingSkills[i-1][2]["NAME"] == "SWITCH":
				update_combat_text(pendingSkills[i-1])
				
				animate_sprite(pendingSkills[i-1][0]["NODE"],SENDOUT)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				if pendingSkills[i-1][0] == playerFront:
					load_front_player(pendingSkills[i-1][1])
				elif pendingSkills[i-1][0] == playerBack:
					load_back_player(pendingSkills[i-1][1])
				
				animate_sprite(pendingSkills[i-1][0]["NODE"],SENDIN)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				
				pendingSkills.erase(pendingSkills[i-1])
			
		for i in range (pendingSkills.size(),0,-1):
			if pendingSkills[i-1][2]["TYPE"] == "ITEM":
				update_combat_text(pendingSkills[i-1])
				
				animate_sprite(pendingSkills[i-1][0]["NODE"],SUPPORT)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				var statName = pendingSkills[i-1][2]["STAT"]
				var newValue = pendingSkills[i-1][2]["MODIFIERS"]
				if statName == "CURRENT HP":
					pendingSkills[i-1][1]["CURRENT HP"] += newValue
				else:
					pendingSkills[i-1][1]["MODIFIERS"] += {statName:newValue}
				
				update_ui_action_bars(pendingSkills[i-1][0]["UI NODE"],pendingSkills[i-1][2])
				update_ui_health_bar(pendingSkills[i-1][1]["UI NODE"],pendingSkills[i-1][1]["CURRENT HP"])
				
				GlobalPlayer.use_item(pendingSkills[i-1][2]["NAME"],pendingSkills[i-1][2]["ITEM INDEX"],1)
				pendingSkills.erase(pendingSkills[i-1])
		for i in range (pendingSkills.size(),0,-1):
#			print (debug_pendingSkills(), "\n Loop ",i)
			if pendingSkills[i-1][2]["TYPE"] == "SUPPORT":
				pendingSkills[i-1][1]["MODIFIERS"] = {[pendingSkills[i-1][2]["STAT"]]: pendingSkills[i-1][2]["STAT MOD"]}
				update_combat_text(pendingSkills[i-1])
				animate_sprite(pendingSkills[i-1][0]["NODE"],SUPPORT)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				update_ui_action_bars(pendingSkills[i-1][0]["UI NODE"],pendingSkills[i-1][2])
				
				spend_energy(pendingSkills[i-1][0],pendingSkills[i-1][2])
				if AllyGolems.has(pendingSkills[i-1][0]):
					playerUsedSupport = true
				
				
				pendingSkills.erase(pendingSkills[i-1])
				
#				print (debug_pendingSkills(), "\n Loop ",i) * BROKEN DUE TO Passing SWITCH as a STRING VS SKILL
		pendingSkills.sort_custom(self,"sort_by_speed")
		for i in range (pendingSkills.size(),0,-1):
#			print (debug_pendingSkills(), "\n Loop ",i)* BROKEN DUE TO Passing SWITCH as a STRING VS SKILL
			if pendingSkills[i-1][2]["TYPE"] == "DEFEND":
				pendingSkills[i-1][1]["MODIFIERS"] = {[pendingSkills[i-1][2]["STAT"]]:pendingSkills[i-1][2]["STAT MOD"]}
				update_combat_text(pendingSkills[i-1])
				animate_sprite(pendingSkills[i-1][0]["NODE"],DEFEND)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				update_ui_action_bars(pendingSkills[i-1][0]["UI NODE"],pendingSkills[i-1][2])
				
				spend_energy(pendingSkills[i-1][0],pendingSkills[i-1][2])
				
				pendingSkills.erase(pendingSkills[i-1])
				
#				print (debug_pendingSkills(), "\n Loop ",i)* BROKEN DUE TO Passing SWITCH as a STRING VS SKILL
		pendingSkills.sort_custom(self,"sort_by_speed")
		for i in range (pendingSkills.size(),0,-1):
#			print (debug_pendingSkills(), "\n Loop ",i) * BROKEN DUE TO Passing SWITCH as a STRING VS SKILL
			
			if pendingSkills[i-1][2]["TYPE"] == "ATTACK":
				var damage 
				var attackWithMod
				var targetDefenseWithMod
				if check_if_golem_dead(pendingSkills[i-1][0]): ## Golem is dead and can no longer attack
					pendingSkills.erase(pendingSkills[i-1])
					continue
				elif check_if_golem_dead(pendingSkills[i-1][1]): ## Target Golem is dead, check to see if another is present
					if pendingSkills[i-1][2]["TARGET"] == StatBlocks.TARGET.ALLY: ##Select self instead
						pendingSkills[i-1][1] = pendingSkills[i-1][0]
						
					elif AllyGolems.has(pendingSkills[i-1][0]): ##AllyGolem attacks other enemy instead
						if pendingSkills[i-1][2]["TARGET"] == StatBlocks.TARGET.ENEMY:
							if !EnemyGolems.empty():
								pendingSkills[i-1][1] = EnemyGolems[0]
							else: 
								pendingSkills.erase(pendingSkills[i-1])
								continue
					elif EnemyGolems.has(pendingSkills[i-1][0]): ##EnermyGolem attacks other playerGolem instead
						if pendingSkills[i-1][2]["TARGET"] == StatBlocks.TARGET.ENEMY:
							if !AllyGolems.empty():
								pendingSkills[i-1][1] = AllyGolems[0]
							else: 
								pendingSkills.erase(pendingSkills[i-1])
								continue
					else: #All targetable attack targets dead
						pendingSkills.erase(pendingSkills[i-1])
						continue
						
#				check_if_golem_dead(pendingSkills[i-1][1])
#				check_if_golem_dead_and_redirect(pendingSkills[i-1][1])
				if pendingSkills[i-1][2]["IMPACT TYPE"] == "PHYSICAL":
					attackWithMod =  pendingSkills[i-1][0]["ATTACK"] #Base Attack
					targetDefenseWithMod = pendingSkills[i-1][0]["DEFENSE"]
					if !pendingSkills[i-1][0]["MODIFIERS"].empty():
						if pendingSkills[i-1][0]["MODIFIERS"].has("ATTACK"):
							attackWithMod *= pendingSkills[i-1][0]["MODIFIERS"]["ATTACK"]
					if !pendingSkills[i-1][1]["MODIFIERS"].empty():
						if pendingSkills[i-1][1]["MODIFIERS"].has("DEFENSE"):
							targetDefenseWithMod *= pendingSkills[i-1][1]["MODIFIERS"]["DEFENSE"]
						
				elif pendingSkills[i-1][2]["IMPACT TYPE"] == "MAGICAL":
					attackWithMod =  pendingSkills[i-1][0]["MAGIC ATTACK"] #Base Attack
					targetDefenseWithMod = pendingSkills[i-1][0]["MAGIC DEFENSE"]
					if !pendingSkills[i-1][0]["MODIFIERS"].empty():
						if pendingSkills[i-1][0]["MODIFIERS"].has("MAGIC ATTACK"):
							attackWithMod *= pendingSkills[i-1][0]["MODIFIERS"]["MAGIC ATTACK"]
					
					if !pendingSkills[i-1][1]["MODIFIERS"].empty():
						if pendingSkills[i-1][1]["MODIFIERS"].has("MAGIC DEFENSE"):
							targetDefenseWithMod *= pendingSkills[i-1][1]["MODIFIERS"]["MAGIC DEFENSE"]
				var skillRand = SeedGenerator.rng.randf_range(pendingSkills[i-1][2]["MIN BONUS"],pendingSkills[i-1][2]["MAX BONUS"]) 
				damage = attackWithMod/targetDefenseWithMod*pendingSkills[i-1][2]["BASE DAMAGE"] * (pendingSkills[i-1][0]["LEVEL"]*0.2)*pendingSkills[i-1][0]["AFFINITY"] * skillRand# * CoreMultiplier * CompostionMultiplier * EnvironmentalMultiplier #
				##DEBUG rounding damage:
				damage = ceil(damage)
				pendingSkills[i-1][1]["CURRENT HP"] -= damage
				
				spend_energy(pendingSkills[i-1][0],pendingSkills[i-1][2])
				
				prompt.get_node("PromptText").text= pendingSkills[i-1][0]["NAME"]+ " is attacking " + pendingSkills[i-1][1]["NAME"]+ " and is doing " + str(damage) + " damage" +"\n"
				prompt.get_node("PromptText").text+= pendingSkills[i-1][1]["NAME"]+ " is at "+ str(pendingSkills[i-1][1]["CURRENT HP"])+ " HP"
				animate_sprite(pendingSkills[i-1][0]["NODE"],ATTACK)
				yield(pendingSkills[i-1][0]["NODE"],"sprite_animation_done")
				animate_sprite(pendingSkills[i-1][1]["NODE"],HIT)
				yield(pendingSkills[i-1][1]["NODE"],"sprite_animation_done")
				update_ui_action_bars(pendingSkills[i-1][0]["UI NODE"],pendingSkills[i-1][2])
				update_ui_health_bar(pendingSkills[i-1][1]["UI NODE"],pendingSkills[i-1][1]["CURRENT HP"])
				
				
				if pendingSkills[i-1][1]["CURRENT HP"]  <=  0:
#					check_for_kill_bonus()
#					pendingSkills[i-1][1]["HP"] = 0
					if EnemyGolems.has(pendingSkills[i-1][1]):
						
						animate_sprite(pendingSkills[i-1][1]["NODE"],DEATH)
						enemy_death(pendingSkills[i-1][1],pendingSkills[i-1][0],pendingSkills[i-1][2])
						yield(pendingSkills[i-1][1]["NODE"],"sprite_animation_done")
					elif AllyGolems.has(pendingSkills[i-1][1]):
						if playerInBattle:
							player_death()
						else:
							player_golem_death(pendingSkills[i-1][1])
							
							if does_void_run_away(pendingSkills[i-1][1]):
								WorldConductor.core_stolen(pendingSkills[i-1][1],pendingSkills[i-1][0])
								void_ran_away(pendingSkills[i-1][0],pendingSkills[i-1][1])
							else:
								GlobalPlayer.add_core(pendingSkills[i-1][1])
				pendingSkills.erase(pendingSkills[i-1])
	GlobalPlayer.isInAnimation = false
	end_turn()
func next_turn():
	if currentBattleState == BATTLESTATE.PLAYERTURN:
		currentBattleState = BATTLESTATE.ENEMYTURN
		enemy_turn()
	else:
		currentBattleState = BATTLESTATE.PLAYERTURN
		player_turn()
func check_end_turn():
	var checkSkills = true
	for i in AllyGolemsSkillUsed.size():
		if !AllyGolemsSkillUsed[i]:
			checkSkills = false
	return checkSkills

func change_selected_golem(newGolem = 1):#, clockwise=true):
	if AllyGolems.size()>1:
#		var rangeMin = 0
#		var rangeMax = AllyGolems.size()
#		var integerCount = 1
#		if !clockwise:
#			rangeMin = rangeMax
#			rangeMax = 0
#			integerCount -1
		var countOfLoops = 0
		while countOfLoops < 2: ##Should only take 2 loops to run though all Golems. If Logic has failed, force exit
			countOfLoops +=1
			for i in AllyGolems.size():#range(rangeMin,rangeMax,integerCount):
				if selectedGolem == AllyGolems[i]:
					newGolem = i+newGolem
					if newGolem > AllyGolems.size()-1:
						newGolem = 0
					elif newGolem <0:
						newGolem = AllyGolems.size()-1
					
					if AllyGolemsSkillUsed[newGolem] == false:
						selectedGolem = AllyGolems[newGolem]
						update_UI_selected_Ally_Golem(selectedGolem)
						return selectedGolem
					elif !AllyGolemsSkillUsed.has(false):
						return selectedGolem
				
func store_choice(from,target,skill):
	pendingSkills.append([from,target,skill])
		
func use_skill(target):
	store_choice(selectedGolem,target,skillBeingUsed)
	for i in AllyGolems.size():
		if selectedGolem == AllyGolems[i]:
			AllyGolemsSkillUsed[i] = true 

	skillBeingUsed = null
	currentSelectionState = SELECTIONSTATE.MAIN
	ui_main_menu_update()
	clear_player_choice(playerSelection)
	update_cursor_location_on_current_SELECTIONSTATE()
	
	if check_end_turn():
		if currentBattleState == BATTLESTATE.PLAYERTURN:
			decide_enemy_move()
			resolve_turn()
		else:
			resolve_turn()
	else:
		change_selected_golem()
#	end_turn()
	pass
func reset_selection():
	ui_main_menu_update()
	change_selected_golem()
	previousPlayerSelection = null
	playerUsedSupport = false
	partyChoice = 0
	itemChoice = 0
	itemUsed = null
	golemSwitch = null
	currentSelectionState = SELECTIONSTATE.MAIN
	for i in AllyGolemsSkillUsed.size():
		AllyGolemsSkillUsed[i] = false
	
func clear_golem_modifers():
	if !AllyGolems.empty():
		for i in AllyGolems.size():
			AllyGolems[i]["MODIFIERS"] = {}
	if !EnemyGolems.empty():
		for i in EnemyGolems.size():
			EnemyGolems[i]["MODIFIERS"] = {}
func end_turn():
#	select_player_choice(playerSelection)
	if EnemyGolems.empty():
		win_battle()
	
	else:
		reset_selection()
		clear_golem_modifers()
		next_turn()
		update_global_golems()
	
func void_loot(golemToDie,golemThatKilled=null,skillUsedToKill=null):
	var lootTable = golemToDie["NORMAL LOOT DROP"]
	var itemName = lootTable.keys()
	var bonus = check_for_kill_bonus(golemToDie, golemThatKilled,skillUsedToKill)
	######  Golem Name  ###########
	if !lootToWin.empty():
		lootToWin.append("\n")
	lootToWin.append(golemToDie["NAME"])
	###############################
	
	##### ROLLING FOR NORMAL LOOT#################
	if !bonus.empty():
		for i in bonus.size():
			lootToWin.append(bonus[i])
	if !itemName.empty():
		for i in itemName.size():
			lootToWin.append([itemName[i],ceil(lootTable[itemName[i]]*lootModifier)])
	if golemToDie.has("UNIQUE LOOT DROP"):
		var uniqueLootTable = golemToDie["UNIQUE LOOT DROP"]
		var uniqueItemName = lootTable.keys()
		for i in uniqueItemName.size():
			lootToWin.append([uniqueItemName[i],uniqueLootTable[uniqueItemName[i]]])
	##### ROLLING FOR Rare LOOT#################
	var rareLootTable = golemToDie["RARE LOOT DROP"]
	var rareItemName = rareLootTable.keys()
	if !rareItemName.empty():
		for i in rareItemName.size():
			var chance = 0.2
			chance *= lootModifier
			var rollForLoot = SeedGenerator.rng.randf_range(0,1)
			if chance <= rollForLoot:
				lootToWin.append([rareItemName[i],rareLootTable[rareItemName[i]]])
	lootModifier = 1.0

func check_for_kill_bonus(golemToDie,golemThatKilled=null,skillUsedToKill=null):
	var listOfKillSpecial = []
	var currentHP = golemToDie["CURRENT HP"]
	var OverDamge = -1* currentHP
	var maxHP = golemToDie["HP"]
	var ExactKillPercent = .01 #Percentage to compare against the ExactKill Stat
	var OverKillPercent = .20 #Percentage to compare against the OverKill Stat
	if OverDamge <= floor(golemToDie["CURRENT HP"]*ExactKillPercent) and OverDamge >=0:
		listOfKillSpecial.append("Exact Kill Bonus")
		lootModifier += 0.4
	if OverDamge >= ceil(golemToDie["CURRENT HP"]*OverKillPercent) :
		listOfKillSpecial.append("OverKill Bonus")
		lootModifier += 0.7
		
	################LINK KILL#########################
	if golemThatKilled != null:
		if !golemThatKilled["MODIFIERS"].empty():
			var keys =golemThatKilled["MODIFIERS"].keys()
			var positiveBuff = false
			###Attacking Golem is Buffed check
			for i in keys.size():
				if golemThatKilled["MODIFIERS"][keys[i]] >= 1: #####################################NEED BETTER LOGIC TO SEE IF ALLY GOLEM USED SKILL?
					positiveBuff = true
			if positiveBuff:
				listOfKillSpecial.append("Link Kill Bonus")
				lootModifier += 0.7
	###############DEBUFF KILL########################
	if !golemToDie["MODIFIERS"].empty():
		var keys =golemToDie["MODIFIERS"].keys()
		var negativeBuff = false
		###Attacking Golem is Buffed check
		for i in keys.size():
			if golemToDie["MODIFIERS"][keys[i]] < 1: #####################################NEED BETTER LOGIC TO SEE IF ALLY GOLEM USED SKILL?
				negativeBuff = true
		if negativeBuff:
			listOfKillSpecial.append("Debuff Kill Bonus")
			lootModifier += 0.4
	################ELEMENTS ##########################
	
	if skillUsedToKill != null:
	##############Nature##############################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Nature:
			listOfKillSpecial.append("Nature Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Nature):
			listOfKillSpecial.append("Nature Kill Bonus")
			lootModifier += 0.2
			
			
			
	
	
	#################Lightning########################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Lightning:
			listOfKillSpecial.append("Lightning Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Lightning):
			listOfKillSpecial.append("Lightning Kill Bonus")
			lootModifier += 0.2
	#################Water############################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Water:
			listOfKillSpecial.append("Water Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Water):
			listOfKillSpecial.append("Water Kill Bonus")
			lootModifier += 0.2
	#################Fire############################# 
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Fire:
			listOfKillSpecial.append("Fire Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Fire):
			listOfKillSpecial.append("Fire Kill Bonus")
			lootModifier += 0.2
	##################Ice#############################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Ice:
			listOfKillSpecial.append("Ice Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Ice):
			listOfKillSpecial.append("Ice Kill Bonus")
			lootModifier += 0.2
	##################Wind############################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Wind:
			listOfKillSpecial.append("Wind Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Wind):
			listOfKillSpecial.append("Wind Kill Bonus")
			lootModifier += 0.2
	##################Void############################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Void:
			listOfKillSpecial.append("Void Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Void):
			listOfKillSpecial.append("Void Kill Bonus")
			lootModifier += 0.2
	##################Divine########################## 
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Divine:
			listOfKillSpecial.append("Divine Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Divine):
			listOfKillSpecial.append("Divine Kill Bonus")
			lootModifier += 0.2
	###################Mundane#########################
		if skillUsedToKill["ASPECT"] == StatBlocks.ELEMENT.Mundane:
			listOfKillSpecial.append("Mundane Kill Bonus")
			lootModifier += 0.2
		elif golemToDie["DAMAGE OVER TIME"].has(StatBlocks.ELEMENT.Mundane):
			listOfKillSpecial.append("Mundane Kill Bonus")
			lootModifier += 0.2
	return listOfKillSpecial

func enemy_death(golemToDie,golemThatKilled=null,skillUsedToKill=null):
	void_loot(golemToDie,golemThatKilled,skillUsedToKill)
	if EnemyGolems.size() > 1:
		lose_1_enemy()
#		if enemyFront == golemToDie:
#		animate_sprite(golemToDie["NODE"],DEATH)
#			yield(EnemyGolems[0]["NODE"],"sprite_animation_done")
		EnemyGolems.erase(golemToDie)
		load_front_enemy(EnemyGolems[0])
#		elif enemyBack == golemToDie:
#			animate_sprite(golemToDie["NODE"],DEATH)
##			yield(EnemyGolems[1]["NODE"],"sprite_animation_done")
#			EnemyGolems.remove(1)

	else:
		EnemyGolems.remove(0)
		sceneSetup.play("WIN")
	pass

func player_golem_death(golemToDie):
	animate_sprite(golemToDie["NODE"],DEATH)
	if AllyGolems.size() > 1:
		GlobalPlayer.remove_golem(golemToDie)
		lose_1_player()
		if playerFront == AllyGolems[0]:
#			yield(AllyGolems[0]["NODE"],"sprite_animation_done")
			AllyGolems.remove(0)
			load_front_player(AllyGolems[0])
		elif enemyBack == AllyGolems[1]:
			
			GlobalPlayer.remove_golem(golemToDie)
#			animate_sprite(AllyGolems[1]["NODE"],DEATH)
#			yield(AllyGolems[1]["NODE"],"sprite_animation_done")
			AllyGolems.remove(1)
	elif !playerInBattle:
		playerInBattle = true
		AllyGolems.remove(0)
		load_front_player(GlobalPlayer.PLAYERSTATS)
		AllyGolems.append(GlobalPlayer.PLAYERSTATS)
		
	pass

func does_void_run_away(golemDying):
	var rollForChance = SeedGenerator.rng.randf_range(0,1)
	if voidChanceToRun <= rollForChance:
		return true
	return false
	
func player_death():
	get_tree().reload_current_scene()
	pass
func win_battle():
	battleWinScreen.show()
	currentMenu = MENU.WIN
	battleWon = true
	var lootLabel = battleWinScreen.get_node("Label")
	lootLabel.text = "You Won:\n"
	lootLabel.text += generate_loot_text()
	update_global_golems()

func lose_battle():
	battleWinScreen.show()
	currentMenu = MENU.WIN
	battleWon = true
	var lootLabel = battleWinScreen.get_node("Label")
	lootLabel.text = "You Fled:"
	lootLabel.text += generate_loot_text()
	update_global_golems()
	
func void_ran_away(voidTaker,coreTaken = null):
	battleWinScreen.show()
	currentMenu = MENU.WIN
	battleWon = true
	update_global_golems()
	var lootLabel = battleWinScreen.get_node("Label")
	if EnemyGolems.size() > 1:
		lootLabel.text = "Both Voids have escaped!\n"
	else:lootLabel.text = voidTaker["NAME"] + " has escaped!\n"
	if coreTaken != null:
		lootLabel.text += voidTaker["NAME"] + " took " + coreTaken["NAME"]+"'s core"
	
	lootLabel.text += generate_loot_text()
	
func generate_loot_text():
	var textToPrint = ""
	for i in lootToWin.size():
		if lootToWin[i] is String:
			textToPrint += lootToWin[i] + "\n"
		else:
			var itemName = lootToWin[i][0]
			var qty = lootToWin[i][1]
			if typeof(qty) == TYPE_INT or typeof(qty) == TYPE_REAL :
				GlobalPlayer.add_loot(itemName,qty)
				textToPrint += itemName + " x"+ str(qty) +"\n"
			elif typeof(qty) == TYPE_STRING:
				if qty == "CORE":
					itemName = GlobalPlayer.add_core(itemName)
					textToPrint += itemName +"\n"
					
	return textToPrint

func update_global_golems():
	for i in AllyGolems.size():
		GlobalPlayer.update_golem(AllyGolems[i])
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
	
	if currentSelectionState == SELECTIONSTATE.MAIN or currentBattleState == SELECTIONSTATE.SECONDARY:
		if previousPlayerSelection != null:
			playerSelection = previousPlayerSelection
			previousPlayerSelection = null
		else:playerSelection=3 
	elif currentSelectionState == SELECTIONSTATE.ENEMY:
		playerSelection = 80
		
	elif currentSelectionState == SELECTIONSTATE.ALLY:
		playerSelection = 90
	
	elif currentSelectionState == SELECTIONSTATE.BOTH:
		playerSelection = 80
	
	update_player_choice(playerSelection)
		
func secondary_combat_options():
	if currentSelectionState == SELECTIONSTATE.MAIN:
		ui_secondary_menu_update()
		
	else:
		ui_main_menu_update()
		
	

	
func ui_cancel(arrowKeySelection = false):
#	if currentSelectionState != SELECTIONSTATE.MAIN or currentSelectionState != SELECTIONSTATE.SECONDARY:
#		currentSelectionState = SELECTIONSTATE.MAIN
#		update_cursor_location_on_current_SELECTIONSTATE()
#		skillBeingUsed = null
	if currentMenu == MENU.ITEM or currentMenu == MENU.PARTY:
		clear_player_choice(playerSelection)
		previousPlayerSelection=null
		playerSelection = currentMenu-1
		update_player_choice(playerSelection)
		currentMenu = MENU.NONE
		ui_secondary_menu_update()
		selectableSkillOptions = []
	elif currentMenu != MENU.NONE:
		clear_player_choice(playerSelection)
		previousPlayerSelection=null
		playerSelection = currentMenu +3
		update_player_choice(playerSelection)
		currentMenu = MENU.NONE
		ui_main_menu_update()
		selectableSkillOptions = []
#	elif

#		elif currentMenu == MENU.NONE:
#			if playerSelection >= 3 and playerSelection <=6:
#				currentMenu = playerSelection-3
#				clear_player_choice(playerSelection)
#				previousPlayerSelection = playerSelection
#				playerSelection = 3
#				update_player_choice(playerSelection)
#				if currentSelectionState == SELECTIONSTATE.MAIN:
#					update_skills(selectedGolem,currentMenu)
#				elif currentSelectionState == SELECTIONSTATE.SECONDARY:
#					update_secondary(selectedGolem,currentMenu+4)
	pass
func move_right():
	clear_player_choice(playerSelection)
	if playerSelection == 1:
		playerSelection = 2
	elif playerSelection == 2:
		playerSelection = 1
	elif currentSelectionState == SELECTIONSTATE.MAIN and currentMenu == MENU.NONE:
		secondary_combat_options()
	elif currentSelectionState == SELECTIONSTATE.SECONDARY and currentMenu == MENU.NONE:
		ui_main_menu_update()
		
	
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
	elif currentSelectionState == SELECTIONSTATE.BOTH:
		if playerSelection == 80:
			playerSelection=81
		elif playerSelection == 81:
			playerSelection=80
		elif playerSelection == 90:
			playerSelection=91
		elif playerSelection == 91:
			playerSelection=90
	update_player_choice(playerSelection)
func move_left():
	clear_player_choice(playerSelection)

	if playerSelection == 1:
		playerSelection = 2
	elif playerSelection == 2:
		playerSelection = 1
	elif currentSelectionState == SELECTIONSTATE.MAIN and currentMenu == MENU.NONE:
		secondary_combat_options()
	elif currentSelectionState == SELECTIONSTATE.SECONDARY  and currentMenu == MENU.NONE:
		ui_main_menu_update()
		
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
			
	elif currentSelectionState == SELECTIONSTATE.BOTH:
		if playerSelection == 80:
			playerSelection=81
		elif playerSelection == 81:
			playerSelection=80
		elif playerSelection == 90:
			playerSelection=91
		elif playerSelection == 91:
			playerSelection=90
	update_player_choice(playerSelection)
func update_partyChoice(num = 1):
	partyChoice += num
	if partyChoice < 0:
		partyChoice = maxParty-1
	elif partyChoice > maxParty-1:
		partyChoice = 0
#	print ("partyChoice = ", partyChoice)
func update_itemChoice(num = 1):
	itemChoice += num
	if itemChoice < 0:
		itemChoice = listOfUseableItems.size()-1
	elif itemChoice > listOfUseableItems.size()-1:
		itemChoice = 0
#	print (itemChoice)
	
func move_up():
	clear_player_choice(playerSelection)

	if currentMenu == MENU.PARTY:
		if playerSelection == 3:
			update_partyChoice(-1)
			update_golem_list(partyChoice)
		else: 
			playerSelection -= 1
			update_partyChoice(-1)
	elif currentMenu == MENU.ITEM:
		if playerSelection == 3:
			update_itemChoice(-1)
			update_item_list(itemChoice)
		else: 
			playerSelection -= 1
			update_itemChoice(-1)
	
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
			
	elif currentSelectionState == SELECTIONSTATE.BOTH:
		if playerSelection == 80:
			playerSelection=90
		elif playerSelection == 81:
			playerSelection=91
		elif playerSelection == 90:
			playerSelection=80
		elif playerSelection == 91:
			playerSelection=81
		
	else:
		if playerSelection == 1:
			playerSelection = 6
		else: playerSelection -= 1
		
	update_player_choice(playerSelection)
	
func move_down():
	clear_player_choice(playerSelection)
	
	if currentMenu == MENU.PARTY:
		if playerSelection == 6:
			update_partyChoice(1)
			update_golem_list(partyChoice-3)
		else: 
			update_partyChoice(1)
			playerSelection += 1
	elif currentMenu == MENU.ITEM:
		if playerSelection == 6:
			update_itemChoice(1)
			update_item_list(itemChoice-3)
		else: 
			update_itemChoice(1)
			playerSelection += 1
		
		
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
	elif currentSelectionState == SELECTIONSTATE.BOTH:
		if playerSelection == 80:
			playerSelection=90
		elif playerSelection == 81:
			playerSelection=91
		elif playerSelection == 90:
			playerSelection=80
		elif playerSelection == 91:
			playerSelection=81
		
	else:
		if playerSelection == 6:
			playerSelection = 1
		else: playerSelection += 1
	
	update_player_choice(playerSelection)
	
func ui_accept(arrowKeySelection = false):
	if waitingForPlayerInput:
		if currentSelectionState == SELECTIONSTATE.ENEMY  :
			if playerSelection == 80:
				use_skill(enemyFront)
			elif playerSelection == 81:
				use_skill(enemyBack)
		elif currentSelectionState == SELECTIONSTATE.ALLY:
			if playerSelection == 90:
				use_skill(playerFront)
			elif playerSelection == 91:
				use_skill(playerBack)
		elif currentSelectionState == SELECTIONSTATE.BOTH:
			if playerSelection == 80:
				use_skill(enemyFront)
			elif playerSelection == 81:
				use_skill(enemyBack)
			elif playerSelection == 90:
				use_skill(playerFront)
			elif playerSelection == 91:
				use_skill(playerBack)
			
			
		elif currentMenu == MENU.NONE:
			if playerSelection >= 3 and playerSelection <=6:
				currentMenu = playerSelection-3
				clear_player_choice(playerSelection)
				previousPlayerSelection = playerSelection
				playerSelection = 3
				update_player_choice(playerSelection)
				if currentSelectionState == SELECTIONSTATE.MAIN:
					update_skills(selectedGolem,currentMenu)
				elif currentSelectionState == SELECTIONSTATE.SECONDARY:
					update_secondary(selectedGolem,currentMenu+4) #this is for the MENU.ENUMS provided, going through the list integers
		elif currentMenu == MENU.ATTACK:
			if selectableSkillOptions[playerSelection-3]: ##-3 to get the 0-3 array
				skillBeingUsed = select_skill(playerSelection-2) ##needs a number 1-4 to find and select the skill node in question
			pass
		elif currentMenu == MENU.SUPPORT:
			if selectableSkillOptions[playerSelection-3]:
				skillBeingUsed = select_skill(playerSelection-2) ##needs a number 1-4 to find and select the skill node in question
			pass
		elif currentMenu == MENU.DEFEND:
			if selectableSkillOptions[playerSelection-3]:
				skillBeingUsed = select_skill(playerSelection-2) ##needs a number 1-4 to find and select the skill node in question
			pass
		elif currentMenu == MENU.PARTY:
			if selectableSkillOptions[playerSelection-3]:
				skillBeingUsed = {"NAME":"SWITCH"}
				golemSwitch = GlobalPlayer.partyGolems[partyChoice]
#				print ("Picked ",golemSwitch["NAME"], " as partyChoice ",partyChoice)
				use_skill(GlobalPlayer.partyGolems[partyChoice].duplicate())
		elif currentMenu == MENU.ITEM:
			if selectableSkillOptions[playerSelection-3]:
				skillBeingUsed = LootTable.UseItemList[listOfUseableItems[itemChoice][0]].duplicate()
				skillBeingUsed["NAME"] = listOfUseableItems[itemChoice][0]
				skillBeingUsed["TYPE"] = "ITEM"
				skillBeingUsed["ITEM INDEX"] = listOfUseableItems[itemChoice][2]
				
				var itemTarget = LootTable.UseItemList[listOfUseableItems[itemChoice][0]]["TARGET"]
				if itemTarget == StatBlocks.TARGET.ALLY:
					currentSelectionState = SELECTIONSTATE.ALLY
				elif itemTarget == StatBlocks.TARGET.ENEMY:
					currentSelectionState = SELECTIONSTATE.ENEMY
				elif itemTarget == StatBlocks.TARGET.BOTH:
					currentSelectionState = SELECTIONSTATE.BOTH
				itemUsed =listOfUseableItems[itemChoice]
				itemUsed[1] = 1
			update_cursor_location_on_current_SELECTIONSTATE()
#				use_skill(GlobalPlayer.partyGolems[partyChoice].duplicate())
		elif currentMenu == MENU.WIN:
			get_parent()._enemy_battle_end()
			
func switch_Golem(clockwise = true):
	if clockwise:
		change_selected_golem(1)
	else:change_selected_golem(-1)

func update_UI_selected_Ally_Golem(newGolemSelected = selectedGolem):
	if currentMenu == MENU.NONE:
		for i in AllyGolems.size():
			AllyGolems[i]["NODE"].cursor_visible(false)
		newGolemSelected["NODE"].cursor_visible(true)
	
	pass
	
func load_in():
	sceneLoadInAndOut.play("OverworldBattleIn")
func load_out():
	sceneLoadInAndOut.play("OverworldBattleOut")
func _on_SceneLoadInAndOut_animation_finished(anim_name):
	if anim_name == "OverworldBattleOut":
		self.queue_free()
	pass # Replace with function body.
