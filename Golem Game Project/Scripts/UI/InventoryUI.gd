extends Control
enum {MOVE,USE,PLACE,DISCARD}
var currentState = null

onready var inventorySlots = $BookMarginContainer/BookBackground/Items
onready var inventoryPlayerSelection = $BookMarginContainer/BookBackground/PlayerSelectionInventory
onready var inventoryPageTurning = $BookMarginContainer/BookBackground/InventoryPageTurning
onready var partyMemberSelection = $BookMarginContainer/BookBackground/PlayerSelectionPartyMenu
onready var partySlots = $BookMarginContainer/BookBackground/PartyMenu

var subMenuInventoryScene = load("res://Scenes/UI/SubInventoryMenu.tscn")
var subMenuNode
var inventoryPage = 0
var playerCurrentSelection = 0

var nodeSelected = null
var nodeToMove = null
var indexToMove = null
var inventoryHighlightToMove = null

signal sub_menu
# Called when the node enters the scene tree for the first time.
func _ready():
	load_golems()
	pass # Replace with function body.

func update_inventory():
	var startingInventory = inventoryPage * inventorySlots.get_child_count()
	for i in range (startingInventory,inventorySlots.get_child_count(),1):
		if GlobalPlayer.itemIndexDict.has(i):
			var nextItem = GlobalPlayer.itemIndexDict[i]
			var nextQuantity = GlobalPlayer.inventoryListDict[nextItem][i]
			inventorySlots.get_child(i).set_item(nextItem,GlobalPlayer.inventoryListDict[nextItem][i])
		else:inventorySlots.get_child(i).reset()
	current_player_selection_highlight (playerCurrentSelection)
	
func current_player_selection_highlight (currentSelection):
	
	if currentSelection >= 0 and currentSelection <= 15:
		inventoryPlayerSelection.get_child(currentSelection).modulate.a = 1.0
		nodeSelected = inventorySlots.get_child(currentSelection)
	elif currentSelection == 16:
		inventoryPageTurning.get_node("BackButton").modulate =  Color( 0, 0, 0, 1 ) ##BLACK
		nodeSelected = inventoryPageTurning.get_node("BackButton")
	elif currentSelection == 17:
		inventoryPageTurning.get_node("NextButton").modulate =  Color( 0, 0, 0, 1 ) ##BLACK
		nodeSelected = inventoryPageTurning.get_node("NextButton")
	elif currentSelection >= 18 and currentSelection <= 23:
		partyMemberSelection.get_child(currentSelection-18).modulate.a = 1.0
		nodeSelected = partyMemberSelection.get_child(currentSelection-18)
	playerCurrentSelection = currentSelection

func remove_previous_selection_highlight (previousSelection):
	if inventoryHighlightToMove != null:
		if previousSelection == inventoryHighlightToMove:
			return
	if previousSelection >= 0 and previousSelection <= 15:
		inventoryPlayerSelection.get_child(previousSelection).modulate.a = 0.0
	elif previousSelection == 16:
		inventoryPageTurning.get_node("BackButton").modulate = Color(1,1,1,1)
	elif previousSelection == 17:
		inventoryPageTurning.get_node("NextButton").modulate = Color(1,1,1,1)
	elif previousSelection >= 18 and previousSelection <= 23:
		partyMemberSelection.get_child(previousSelection-18).modulate.a = 0.0
	
	
func load_golems():
	var golemList = GlobalPlayer.partyGolems
	for i in golemList.size():
		
		partySlots.get_child(i).load_golem(golemList[i])
	pass
func reset_all_selections():
	for i in inventoryPlayerSelection.get_child_count():
		inventoryPlayerSelection.get_child(i).modulate.a = 0.0

	inventoryPageTurning.get_node("BackButton").modulate = Color(1,1,1,1)
	inventoryPageTurning.get_node("NextButton").modulate = Color(1,1,1,1)
	
	for i in partyMemberSelection.get_child_count():
		partyMemberSelection.get_child(i).modulate.a = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func move_right():
	
	var newNumber
	if currentState == MOVE:
		if playerCurrentSelection == 3:
			newNumber = 0
		elif playerCurrentSelection == 7:
			newNumber = 4
		elif playerCurrentSelection == 11:
			newNumber = 8
		elif playerCurrentSelection == 15:
			newNumber = 12
		elif playerCurrentSelection == 17:
			newNumber = 16
		else:newNumber = playerCurrentSelection + 1
	else:
		if playerCurrentSelection == 3:
			newNumber = 18
		elif playerCurrentSelection == 7:
			newNumber = 19
		elif playerCurrentSelection == 11:
			newNumber = 20
		elif playerCurrentSelection == 15:
			newNumber = 21
		elif playerCurrentSelection == 18:
			newNumber = 0
		elif playerCurrentSelection == 19:
			newNumber = 0
		elif playerCurrentSelection == 20:
			newNumber = 4
		elif playerCurrentSelection == 21:
			newNumber = 8
		elif playerCurrentSelection == 22:
			newNumber = 12
		elif playerCurrentSelection == 23:
			newNumber = 16
		elif playerCurrentSelection == 17:
			newNumber = 23
		else:newNumber = playerCurrentSelection + 1
	remove_previous_selection_highlight(playerCurrentSelection)
	current_player_selection_highlight(newNumber)
	
	pass
func move_left():
	
	var newNumber
	if currentState == MOVE:
		if playerCurrentSelection == 0:
			newNumber = 3
		elif playerCurrentSelection == 4:
			newNumber = 7
		elif playerCurrentSelection == 8:
			newNumber = 11
		elif playerCurrentSelection == 12:
			newNumber = 15
		elif playerCurrentSelection == 16:
			newNumber = 17
		else:newNumber = playerCurrentSelection - 1
	else:
		if playerCurrentSelection == 0:
			newNumber = 18
		elif playerCurrentSelection == 4:
			newNumber = 19
		elif playerCurrentSelection == 8:
			newNumber = 20
		elif playerCurrentSelection == 12:
			newNumber = 21
		elif playerCurrentSelection == 16:
			newNumber = 23
		elif playerCurrentSelection == 18:
			newNumber = 3
		elif playerCurrentSelection == 19:
			newNumber = 3
		elif playerCurrentSelection == 20:
			newNumber = 7
		elif playerCurrentSelection == 21:
			newNumber = 11
		elif playerCurrentSelection == 22:
			newNumber = 15
		elif playerCurrentSelection == 23:
			newNumber = 17
		elif playerCurrentSelection == 16:
			newNumber = 23
		else:newNumber = playerCurrentSelection - 1
	remove_previous_selection_highlight(playerCurrentSelection)
	current_player_selection_highlight(newNumber)
	
	pass
func move_up():
	var newNumber
	if currentState == MOVE:
		if playerCurrentSelection == 0:
			newNumber = 12
		elif playerCurrentSelection == 1:
			newNumber = 16
		elif playerCurrentSelection == 2:
			newNumber = 17
		elif playerCurrentSelection == 3:
			newNumber = 15
		elif playerCurrentSelection == 16:
			newNumber = 13
		elif playerCurrentSelection == 17:
			newNumber = 14
		elif playerCurrentSelection >= 4 and playerCurrentSelection<=15:
			newNumber = playerCurrentSelection-4
	else:
		if playerCurrentSelection == 0:
			newNumber = 12
		elif playerCurrentSelection == 1:
			newNumber = 16
		elif playerCurrentSelection == 2:
			newNumber = 17
		elif playerCurrentSelection == 3:
			newNumber = 15
		elif playerCurrentSelection == 16:
			newNumber = 13
		elif playerCurrentSelection == 17:
			newNumber = 14
		elif playerCurrentSelection == 18:
			newNumber = 23
		elif playerCurrentSelection >= 4 and playerCurrentSelection<=15:
			newNumber = playerCurrentSelection-4
		else:newNumber = playerCurrentSelection - 1
	remove_previous_selection_highlight(playerCurrentSelection)
	current_player_selection_highlight(newNumber)
func move_down():
	var newNumber
	if currentState == MOVE:
		if playerCurrentSelection == 12:
			newNumber = 0
		elif playerCurrentSelection == 13:
			newNumber = 16
		elif playerCurrentSelection == 14:
			newNumber = 17
		elif playerCurrentSelection == 15:
			newNumber = 3
		elif playerCurrentSelection == 16:
			newNumber = 1
		elif playerCurrentSelection == 17:
			newNumber = 2
		elif playerCurrentSelection >= 0 and playerCurrentSelection<=11:
			newNumber = playerCurrentSelection+4
	else:
		if playerCurrentSelection == 12:
			newNumber = 0
		elif playerCurrentSelection == 13:
			newNumber = 16
		elif playerCurrentSelection == 14:
			newNumber = 17
		elif playerCurrentSelection == 15:
			newNumber = 3
		elif playerCurrentSelection == 16:
			newNumber = 1
		elif playerCurrentSelection == 17:
			newNumber = 2
		elif playerCurrentSelection == 23:
			newNumber = 18
		elif playerCurrentSelection >= 0 and playerCurrentSelection<=11:
			newNumber = playerCurrentSelection+4
		
		else:newNumber = playerCurrentSelection + 1
	remove_previous_selection_highlight(playerCurrentSelection)
	current_player_selection_highlight(newNumber)

func selected():
	if nodeSelected is TextureButton:
		nodeSelected.pressed = true
	elif currentState == MOVE:
		GlobalPlayer.swap_item_locations(nodeToMove.type,indexToMove,nodeSelected.type,playerCurrentSelection + inventoryPage*inventorySlots.get_child_count())
		subMenuNode.queue_free()
		currentState = null
		reset_all_selections()
		inventoryHighlightToMove = null
		update_inventory()
	elif playerCurrentSelection >= 0 and playerCurrentSelection<=15:
		emit_signal("sub_menu",true)
		subMenuNode = subMenuInventoryScene.instance()
		add_child(subMenuNode)
		subMenuNode.rect_position = inventoryPlayerSelection.get_child(playerCurrentSelection).rect_position+Vector2(130,80)
		subMenuNode.connect("selected",self,"_on_SubInventoryMenu_selected")
		if nodeSelected.type == null:
			subMenuNode.set_choices(false)
		else:subMenuNode.set_choices(true)
		inventoryHighlightToMove = playerCurrentSelection
		pass
	pass

func sub_move_up():
	subMenuNode.move_up()
	pass
func sub_move_down():
	subMenuNode.move_down()
	pass
func sub_select():
	subMenuNode.select();
func sub_cancel():
	subMenuNode.cancel()
	if currentState == MOVE:
		nodeToMove = null
		indexToMove = null
		emit_signal("sub_menu",true)
		currentState = null
		inventoryHighlightToMove = null
	else:
		nodeToMove = null
		indexToMove = null
		emit_signal("sub_menu",false)
		currentState = null
		inventoryHighlightToMove = null
	

func _on_SubInventoryMenu_selected(selected):
#	if nodeSelected.type != null:
	if selected == MOVE:
		nodeToMove = nodeSelected
		indexToMove = playerCurrentSelection + inventoryPage*inventorySlots.get_child_count()
		emit_signal("sub_menu",false)
		currentState = MOVE
	elif selected == USE:
		##########################some use function
#		GlobalPlayer.use_item(nodeSelected.type,playerCurrentSelection + inventoryPage*inventorySlots.get_child_count())
#		get_parent()._use_item(nodeSelected.type, nodeSelected.selectedItemTexture)
#		update_inventory()
#		emit_signal("sub_menu",false)
		
		pass
	elif selected == PLACE:
	##########################some use function
		GlobalPlayer.use_item(nodeSelected.type,playerCurrentSelection + inventoryPage*inventorySlots.get_child_count())
		get_parent()._use_item(nodeSelected.type, nodeSelected.selectedItemTexture)
		update_inventory()
		emit_signal("sub_menu",false)
		
		pass
	elif selected == DISCARD:
		GlobalPlayer.delete_item(nodeSelected.type,inventoryPage * inventorySlots.get_child_count()+playerCurrentSelection)
		update_inventory()
		emit_signal("sub_menu",false)



func _on_BackButton_pressed():
	if inventoryPage > 0:
		inventoryPage -= 1
		update_inventory()
	pass # Replace with function body.


func _on_NextButton_pressed():
	if GlobalPlayer.itemIndexDict.has(inventoryPage*inventorySlots.get_child_count()):
		inventoryPage += 1
		update_inventory()
		
	pass # Replace with function body.
func not_primary():
#	if subMenuNode != null:
#		subMenuNode.queue_free()
	inventoryPage = 0
	playerCurrentSelection = 0
	nodeSelected = null
	nodeToMove = null
	indexToMove = null
	currentState = null
	inventoryHighlightToMove = null
	reset_all_selections()
