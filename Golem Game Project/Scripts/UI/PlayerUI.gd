extends Control

var alertScene = preload("res://Scenes/UI/PopUpAlertText.tscn")
onready var popUpAlertContainer = $PopUpAlertUI/PopUpContainer
onready var inventoryUI = $InventoryUI

enum {NONE,INVENTORY,INVENTORY_SUBMENU}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentMenu = NONE
signal nextTool
signal previousTool
signal useItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	process_player_input();

func _next_Tool():
	emit_signal("nextTool")
	
func _previous_Tool():
	emit_signal("previousTool")

func _use_item(itemID,itemTexture):
	emit_signal("useItem",itemID,itemTexture)

func process_player_input():
	if GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME):
		if Input.is_action_just_released("Next_Tool"):
			_next_Tool();
		elif Input.is_action_just_released("Previous_Tool"):
			_previous_Tool();
		if Input.is_action_just_pressed("Pause"):
			GlobalPlayer.currentPLAYSTATE = GlobalPlayer.PLAYSTATE.PAUSE
			currentMenu = INVENTORY
			inventoryUI.update_inventory()
			inventoryUI.show()
	if GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.PAUSE):
		
		if Input.is_action_just_pressed("Next_Page"):
			pass
		elif Input.is_action_just_pressed("Previous_Page"):
			pass
		if currentMenu == INVENTORY:
			if Input.is_action_just_released("ui_cancel"):
				GlobalPlayer.currentPLAYSTATE = GlobalPlayer.PLAYSTATE.GAME
				inventoryUI.hide()
				currentMenu = NONE
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


func _on_InventoryUI_sub_menu(state):
	if state == true:
		currentMenu = INVENTORY_SUBMENU
	else:currentMenu = INVENTORY
	pass # Replace with function body.

func item_use():
	GlobalPlayer.currentPLAYSTATE = GlobalPlayer.PLAYSTATE.GAME
	inventoryUI.hide()
	currentMenu = NONE
