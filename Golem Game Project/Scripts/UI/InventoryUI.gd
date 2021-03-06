extends Control
enum {MOVE,USE,PLACE,DISCARD,VIEW}
var currentState = null

onready var inventorySlots = $BookMarginContainer/BookBackground/Items
onready var inventoryPlayerSelection = $BookMarginContainer/BookBackground/PlayerSelectionInventory
onready var inventoryPageTurning = $BookMarginContainer/BookBackground/InventoryPageTurning
onready var partyMemberSelection = $BookMarginContainer/BookBackground/PlayerSelectionPartyMenu
onready var partySlots = $BookMarginContainer/BookBackground/PartyMenu
onready var itemDescriptor = $BookMarginContainer/BookBackground/ItemDescriptor

var subMenuInventoryScene = load("res://Scenes/UI/SubInventoryMenu.tscn")

var confirmationScene = load("res://Scenes/UI/UIConfirmationWindow.tscn")

var subMenuNode
var confirmationNode
var inventoryPage = 1
var playerCurrentSelection = 0
var playerPreviousSelection = 0

var nodeSelected = null
var nodeToMove = null
var indexToMove = null
var inventoryHighlightToMove = null

var itemToUse = null

signal sub_menu

signal buttonMoveAudio
signal buttonSelectAudio

func _ready():
	load_golems()

func update_inventory():
	var startingInventory = (inventoryPage-1) * inventorySlots.get_child_count()
	for i in inventorySlots.get_child_count():
		var newIndex = startingInventory +i
		if GlobalPlayer.itemIndexDict.has(newIndex):
			var nextItem = GlobalPlayer.itemIndexDict[newIndex]
			var nextQuantity = GlobalPlayer.inventoryListDict[nextItem][newIndex]
			inventorySlots.get_child(i).set_item(nextItem,GlobalPlayer.inventoryListDict[nextItem][newIndex],newIndex)
		else:inventorySlots.get_child(i).reset()
		if indexToMove == newIndex:
			inventoryHighlightToMove = newIndex-startingInventory
			current_player_selection_highlight(inventoryHighlightToMove)
	current_player_selection_highlight (playerCurrentSelection)
	
func current_player_selection_highlight (currentSelection):
	if currentSelection != null:
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
			nodeSelected = partySlots.get_child(currentSelection-18)
		update_item_descriptor(playerCurrentSelection)
	

func remove_previous_selection_highlight (previousSelection):
	if inventoryHighlightToMove != null:
		if previousSelection == inventoryHighlightToMove:
			return
	if previousSelection != null:
		if previousSelection >= 0 and previousSelection <= 15:
			inventoryPlayerSelection.get_child(previousSelection).modulate.a = 0.0
		elif previousSelection == 16:
			inventoryPageTurning.get_node("BackButton").modulate = Color(1,1,1,1)
		elif previousSelection == 17:
			inventoryPageTurning.get_node("NextButton").modulate = Color(1,1,1,1)
		elif previousSelection >= 18 and previousSelection <= 23:
			partyMemberSelection.get_child(previousSelection-18).modulate.a = 0.0

func update_item_descriptor(selection):
	if selection >= 0 and selection <= 15:
		if nodeSelected != null:
			var itemToDisplay = GlobalPlayer.get_item_and_quantity(nodeSelected.itemIndex)
			if  itemToDisplay != null:
				itemDescriptor.text = itemToDisplay[0]
				return
	itemDescriptor.text = ""
	
func load_golems():
	var golemList = GlobalPlayer.partyGolems
	for i in partySlots.get_child_count():
		partySlots.get_child(i).load_golem(golemList[i])
	current_player_selection_highlight(playerCurrentSelection)
func refresh_golems():
	var golemList = GlobalPlayer.partyGolems
	for i in golemList.size():
		
		partySlots.get_child(i).refresh()
	pass
func reset_all_selections():
	for i in inventoryPlayerSelection.get_child_count():
		inventoryPlayerSelection.get_child(i).modulate.a = 0.0

	inventoryPageTurning.get_node("BackButton").modulate = Color(1,1,1,1)
	inventoryPageTurning.get_node("NextButton").modulate = Color(1,1,1,1)
	
	for i in partyMemberSelection.get_child_count():
		partyMemberSelection.get_child(i).modulate.a = 0.0
	if is_instance_valid(subMenuNode):
		subMenuNode.queue_free()
	if is_instance_valid(confirmationNode):
		confirmationNode.queue_free()
	indexToMove = null
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
	elif currentState == USE:
		newNumber = playerCurrentSelection
	elif currentState == DISCARD:
		confirmationNode.move_right();
		newNumber = playerCurrentSelection
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
	if newNumber != null:
		remove_previous_selection_highlight(playerCurrentSelection)
		playerCurrentSelection = newNumber
		current_player_selection_highlight(newNumber)
		
		emit_signal("buttonMoveAudio")
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
	elif currentState == USE:
		newNumber = playerCurrentSelection
	elif currentState == DISCARD:
		confirmationNode.move_left();
		newNumber = playerCurrentSelection
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
	if newNumber != null:
		remove_previous_selection_highlight(playerCurrentSelection)
		playerCurrentSelection = newNumber
		current_player_selection_highlight(newNumber)
		emit_signal("buttonMoveAudio")
	
	pass
func move_up():
	var newNumber
	if currentState == MOVE:
		if playerCurrentSelection >= 0 and playerCurrentSelection <=17:
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
		elif playerCurrentSelection >= 18 and playerCurrentSelection <=23:
			if playerCurrentSelection == 18:
				newNumber = 23
			else:newNumber = playerCurrentSelection - 1
	elif currentState == USE:
		if playerCurrentSelection == 18:
			newNumber = 23
		else:newNumber = playerCurrentSelection - 1
	elif currentState == DISCARD:
		newNumber = playerCurrentSelection
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
	playerCurrentSelection = newNumber
	current_player_selection_highlight(newNumber)
	
	emit_signal("buttonMoveAudio")
func move_down():
	var newNumber
	if currentState == MOVE:
		if playerCurrentSelection >= 0 and playerCurrentSelection <=17:
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
			
		elif playerCurrentSelection >= 18 and playerCurrentSelection <=23:
			if playerCurrentSelection == 23:
				newNumber = 18
			else:newNumber = playerCurrentSelection + 1
	elif currentState == USE:
		if playerCurrentSelection == 23:
			newNumber = 18
		else:newNumber = playerCurrentSelection + 1
	elif currentState == DISCARD:
		newNumber = playerCurrentSelection
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
	playerCurrentSelection = newNumber
	current_player_selection_highlight(newNumber)
	emit_signal("buttonMoveAudio")
func selected():
	if nodeSelected is TextureButton:
		nodeSelected.emit_signal("pressed")
		emit_signal("buttonSelectAudido")
	elif currentState == MOVE:
		playerPreviousSelection = playerCurrentSelection
		if (playerCurrentSelection >= 0 and playerCurrentSelection<=15):
			GlobalPlayer.swap_item_locations(indexToMove,playerCurrentSelection + (inventoryPage-1)*inventorySlots.get_child_count())
			subMenuNode.queue_free()
			currentState = null
			reset_all_selections()
			inventoryHighlightToMove = null
			update_inventory()
		elif playerCurrentSelection >= 18 and playerCurrentSelection<=23:
			GlobalPlayer.swap_golem_position(indexToMove,playerCurrentSelection-18)
			subMenuNode.queue_free()
			currentState = null
			reset_all_selections()
			inventoryHighlightToMove = null
			load_golems()
		emit_signal("buttonSelectAudio")
	elif currentState == USE:
		playerPreviousSelection = playerCurrentSelection
		print (itemToUse)
		var itemDetails = null
		
		if ItemTable.UseItemList.has(GlobalPlayer.itemIndexDict[itemToUse]):
			itemDetails = ItemTable.UseItemList[GlobalPlayer.itemIndexDict[itemToUse]]
		var golemPosition = playerCurrentSelection-18 ##18 is based off of the number that these options are sitting at
		var golemChosen = GlobalPlayer.partyGolems[golemPosition]
		if itemDetails != null:
			golemChosen[itemDetails["STAT"]] += itemDetails["MODIFIERS"]
			if golemChosen[itemDetails["STAT"]] > golemChosen[itemDetails["STAT"].right(8)]: ###ONLY WOULD WORK IF ALL CURRENT STATS USED BY ITEMS HAVE CURRENT
				golemChosen[itemDetails["STAT"]] = golemChosen[itemDetails["STAT"].right(8)]  
			GlobalPlayer.use_item(GlobalPlayer.itemIndexDict[itemToUse],itemToUse,1)
		
		
		currentState = null
		reset_all_selections()
		inventoryHighlightToMove = null
		itemToUse = null
		update_inventory()
		load_golems()
		emit_signal("buttonSelectAudio")
		
	elif currentState == DISCARD:
		confirmationNode.selected()
		
	elif playerCurrentSelection >= 0 and playerCurrentSelection<=15:
		emit_signal("sub_menu",true)
		subMenuNode = subMenuInventoryScene.instance()
		add_child(subMenuNode)
		subMenuNode.rect_position = inventoryPlayerSelection.get_child(playerCurrentSelection).rect_position+Vector2(130,80)
		subMenuNode.connect("selected",self,"_on_SubInventoryMenu_selected")
		subMenuNode.set_choices(nodeSelected.type)
		inventoryHighlightToMove = playerCurrentSelection
		playerPreviousSelection = playerCurrentSelection
		emit_signal("buttonSelectAudio")
	elif playerCurrentSelection >= 18 and playerCurrentSelection<=23:
		emit_signal("sub_menu",true)
		subMenuNode = subMenuInventoryScene.instance()
		add_child(subMenuNode)
		subMenuNode.rect_position = partyMemberSelection.get_child(playerCurrentSelection-18).rect_position+Vector2(130,80)
		subMenuNode.connect("selected",self,"_on_SubInventoryMenu_selected")
		subMenuNode.set_choices(nodeSelected.type)
		inventoryHighlightToMove = playerCurrentSelection
		playerPreviousSelection = playerCurrentSelection
		emit_signal("buttonSelectAudio")
		pass
	
	
func ui_cancel():
	if currentState == MOVE or currentState == USE or currentState == VIEW:
		remove_previous_selection_highlight(playerCurrentSelection)
		playerCurrentSelection = playerPreviousSelection
		current_player_selection_highlight(playerCurrentSelection)
		emit_signal("sub_menu",true)
		subMenuNode.wake()
		pass
	elif currentState == DISCARD:
		confirmationNode.cancel()
		
		pass
	else:
		get_parent().close_inventory_UI()
	pass
	emit_signal("buttonMoveAudio")
func sub_move_up():
	subMenuNode.move_up()
	emit_signal("buttonMoveAudio")
	pass
func sub_move_down():
	subMenuNode.move_down()
	emit_signal("buttonMoveAudio")
	pass
func sub_select():
	subMenuNode.select();
	emit_signal("buttonMoveAudio")
func sub_cancel():
	subMenuNode.cancel()
	if currentState == MOVE or currentState == USE or currentState == VIEW:
		nodeToMove = null
		indexToMove = null
		emit_signal("sub_menu",false)
		currentState = null
		inventoryHighlightToMove = null
	else:
		nodeToMove = null
		indexToMove = null
		emit_signal("sub_menu",false)
		currentState = null
		inventoryHighlightToMove = null
	emit_signal("buttonMoveAudio")
	

func _on_SubInventoryMenu_selected(selected):
	if selected == MOVE:
		nodeToMove = nodeSelected
		emit_signal("sub_menu",false)
		currentState = MOVE
		if playerCurrentSelection>=0 and playerCurrentSelection <=15:
			indexToMove = playerCurrentSelection + (inventoryPage-1)*inventorySlots.get_child_count()
		elif playerCurrentSelection >=18 and playerCurrentSelection <=23:
			indexToMove = playerCurrentSelection-18
		
		emit_signal("buttonSelectAudio")
	elif selected == USE:
		nodeToMove = nodeSelected
		itemToUse = playerCurrentSelection + (inventoryPage-1)*inventorySlots.get_child_count()
		emit_signal("sub_menu",false)
		currentState = USE
		playerCurrentSelection = 18
		current_player_selection_highlight(playerCurrentSelection)
		
		emit_signal("buttonSelectAudio")
		pass
	elif selected == PLACE:
		
		inventoryHighlightToMove = null
		get_parent()._use_item(nodeSelected.type, nodeSelected.selectedItemTexture,nodeSelected.itemIndex)
		update_inventory()
		emit_signal("sub_menu",false)
		get_parent().close_inventory_UI()
		
		emit_signal("buttonSelectAudio")
		pass
	elif selected == DISCARD:
		
		currentState = DISCARD
		emit_signal("sub_menu",false)
		confirmationNode = confirmationScene.instance()
		self.add_child(confirmationNode)
		confirmationNode.rect_position = subMenuNode.rect_position
		confirmationNode.connect("buttonPressed",self,"confirmedAction")
		
		
		
		
		emit_signal("buttonSelectAudio")
	elif selected == VIEW:
		emit_signal("sub_menu",false)
		get_parent().load_stat_page(GlobalPlayer.partyGolems[playerCurrentSelection-18])
		emit_signal("buttonSelectAudio")

func confirmedAction(state:bool):
	if state == true:
		if nodeSelected.type == "golem":
			GlobalPlayer.remove_golem(GlobalPlayer.partyGolems[playerCurrentSelection-18])
		else:
			GlobalPlayer.delete_item(nodeSelected.type,(inventoryPage-1) * inventorySlots.get_child_count()+playerCurrentSelection)
		inventoryHighlightToMove = null
		update_inventory()
		load_golems()
		reset_all_selections()
		current_player_selection_highlight(playerCurrentSelection)
		currentState = null
	else:
		currentState = null
		emit_signal("sub_menu",true)
		subMenuNode.wake()
	
	emit_signal("buttonSelectAudio")

func _on_BackButton_pressed():
	if inventoryPage > 1:
		var pageinventoryHighlightToMove = inventoryHighlightToMove
		inventoryHighlightToMove =null
		remove_previous_selection_highlight(pageinventoryHighlightToMove)
		inventoryPage -= 1
		update_inventory()
		


func _on_NextButton_pressed():
	if GlobalPlayer.find_largest_index() >= ((inventoryPage)*inventorySlots.get_child_count()):
		inventoryPage += 1
		var pageinventoryHighlightToMove = inventoryHighlightToMove
		inventoryHighlightToMove =null
		remove_previous_selection_highlight(pageinventoryHighlightToMove)
		update_inventory()
		
func not_primary():
	inventoryPage = 1
	playerCurrentSelection = 0
	nodeSelected = null
	nodeToMove = null
	indexToMove = null
	currentState = null
	inventoryHighlightToMove = null
	reset_all_selections()
