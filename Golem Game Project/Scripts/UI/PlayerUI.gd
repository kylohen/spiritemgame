extends Control

var alertScene = preload("res://Scenes/UI/PopUpAlertText.tscn")
onready var popUpAlertContainer = $PopUpAlertUI/PopUpContainer
onready var inventoryUI = $InventoryUI
onready var loreBookUI = $LoreBookUI
onready var craftingBookUI = $CraftingBookUI
#onready var animationPlayer = $AnimationPlayer
onready var battleScreenScene = preload("res://Scenes/Battle/BattleScreen.tscn")
onready var dialogSystemNode = preload("res://Scenes/DialogBox/FullDialogWindow.tscn")
var battleScreen
enum {NONE,INVENTORY,INVENTORY_SUBMENU,LORE,CRAFTING}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentMenu = NONE
var previousPLAYSTATE
signal nextTool
signal previousTool
signal useItem

var MenuDict = {
	0:INVENTORY,
	1:LORE,
	2:CRAFTING,
}
onready var MenuNodeDict = {
	INVENTORY:inventoryUI,
	LORE:loreBookUI,
	CRAFTING:craftingBookUI,
}
var menuTracker = 0

func move_menu(value):
	var oldMenu = MenuDict[menuTracker]
	menuTracker += value
	if menuTracker < 0:
		menuTracker = MenuDict.size()-1
	elif menuTracker > MenuDict.size()-1:
		menuTracker = 0
		
	MenuNodeDict[oldMenu].hide()
	MenuNodeDict[oldMenu].not_primary()

	currentMenu = MenuDict[menuTracker]
	MenuNodeDict[currentMenu].show()
	if currentMenu == INVENTORY:
		inventoryUI.update_inventory()
	
	
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	process_player_input();

func _next_Tool():
	emit_signal("nextTool")
	
func _previous_Tool():
	emit_signal("previousTool")

func _use_item(itemID,itemTexture,itemIndex):
	emit_signal("useItem",itemID,itemTexture,itemIndex)

func process_player_input():
	if GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME):
		if Input.is_action_just_released("Next_Tool"):
			_next_Tool();
		elif Input.is_action_just_released("Previous_Tool"):
			_previous_Tool();
		if Input.is_action_just_pressed("Pause"):
			GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.PAUSE)
			currentMenu = INVENTORY
			inventoryUI.update_inventory()
			inventoryUI.show()
			inventoryUI.load_golems()
	elif GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.PAUSE):
		
		if Input.is_action_just_pressed("Next_Page"):
			move_menu(1)
			pass
		elif Input.is_action_just_pressed("Previous_Page"):
			move_menu(-1)
			pass
		if currentMenu == INVENTORY:
			if Input.is_action_just_released("ui_cancel"):
				close_inventory_UI()
			if Input.is_action_just_pressed("ui_right"):
				inventoryUI.move_right()
			elif Input.is_action_just_pressed("ui_left"):
				inventoryUI.move_left()
			elif Input.is_action_just_pressed("ui_up"):
				inventoryUI.move_up()
			elif Input.is_action_just_pressed("ui_down"):
				inventoryUI.move_down()
			if Input.is_action_just_pressed("ui_accept"):
				inventoryUI.selected()
		elif currentMenu == INVENTORY_SUBMENU:
			if Input.is_action_just_pressed("ui_up"):
				inventoryUI.sub_move_up()
			elif Input.is_action_just_pressed("ui_down"):
				inventoryUI.sub_move_down()
			if Input.is_action_just_pressed("ui_accept"):
				inventoryUI.sub_select()
			if Input.is_action_just_pressed("ui_cancel"):
				inventoryUI.sub_cancel()
		elif currentMenu == LORE:
			if Input.is_action_just_released("ui_cancel"):
				GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME)
				loreBookUI.hide()
				currentMenu = NONE
				loreBookUI.not_primary()
			if Input.is_action_just_pressed("ui_right"):
				loreBookUI.move_right()
			elif Input.is_action_just_pressed("ui_left"):
				loreBookUI.move_left()
			if Input.is_action_just_pressed("ui_accept"):
				loreBookUI.selected()
			
		elif currentMenu == CRAFTING:
			if Input.is_action_just_released("ui_cancel"):
				GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME)
				craftingBookUI.hide()
				currentMenu = NONE
				craftingBookUI.not_primary()
			if Input.is_action_just_pressed("ui_up"):
				craftingBookUI.move_up()
			elif Input.is_action_just_pressed("ui_down"):
				craftingBookUI.move_down()
			if Input.is_action_just_pressed("ui_accept"):
				craftingBookUI.selected()
	elif GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.BATTLE) and !GlobalPlayer.isInAnimation:
		if Input.is_action_just_released("ui_cancel"):
			battleScreen.ui_cancel()
		if Input.is_action_just_pressed("ui_right"):
			battleScreen.move_right()
		elif Input.is_action_just_pressed("ui_left"):
			battleScreen.move_left()
		elif Input.is_action_just_pressed("ui_up"):
			battleScreen.move_up()
		elif Input.is_action_just_pressed("ui_down"):
			battleScreen.move_down()
		if Input.is_action_just_pressed("ui_accept"):
			battleScreen.ui_accept()
		if Input.is_action_just_pressed("Next_Tool"):
			battleScreen.switch_Golem(true) #Clockwise direction
		elif Input.is_action_just_pressed("Previous_Tool"):
			battleScreen.switch_Golem(false) #Counter Clockwise direction
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WorldMap_Field_loot_received(lootType,quantityOfLoot):
	var newAlert = alertScene.instance()
	var childCount = popUpAlertContainer.get_child_count() 
	if childCount >= 3:
		popUpAlertContainer.get_child(0).queue_free()
		childCount -= 1
	
	popUpAlertContainer.add_child(newAlert)
#	move_child(newAlert,0)
	newAlert.set_text("Picked Up: "+lootType+" x"+str(quantityOfLoot))
	
	pass # Replace with function body.

func close_inventory_UI():
	GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME)
	inventoryUI.hide()
	currentMenu = NONE
	inventoryUI.not_primary()

	pass

func _on_InventoryUI_sub_menu(state):
	if state == true:
		currentMenu = INVENTORY_SUBMENU
	else:currentMenu = INVENTORY
	pass # Replace with function body.

func item_use():
	GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME)
	inventoryUI.hide()
	currentMenu = NONE



func _on_Cave_loot_received(lootType,quantityOfLoot):
	var newAlert = alertScene.instance()
	var childCount = popUpAlertContainer.get_child_count() 
	if childCount >= 3:
		popUpAlertContainer.get_child(0).queue_free()
		childCount -= 1
	
	popUpAlertContainer.add_child(newAlert)
#	move_child(newAlert,0)
	newAlert.set_text("Picked Up: "+lootType+" x"+str(quantityOfLoot))
	
	pass # Replace with function body.


func _enemy_battle_start(enemyNode):
	battleScreen = battleScreenScene.instance()
	
	add_child(battleScreen)
	battleScreen.start_encounter(enemyNode)
	battleScreen.load_in()
func _enemy_battle_end():
	battleScreen.load_out()
	GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME)

		
	
	
	pass # Replace with function body.

func run_Dialog(partToUse=null):
	if partToUse != null:
		previousPLAYSTATE = GlobalPlayer.currentPLAYSTATE
		GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.PAUSE)
		GlobalPlayer.isInAnimation = true
		var newDialog = dialogSystemNode.instance()
		newDialog.connect("dialogDone",self,"_on_FullDialogWindow_dialogDone")
		add_child(newDialog)
		newDialog.load_dialogs(partToUse)
		
func _on_FullDialogWindow_dialogDone():
	GlobalPlayer.update_PLAYSTATE(previousPLAYSTATE)
	GlobalPlayer.isInAnimation = false
	
	pass # Replace with function body.
