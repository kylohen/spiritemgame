extends Control
enum {MOVE,USE,PLACE,DISCARD, VIEW}
enum {ITEM,PARTY}
var currentPlayerSelection = 0
var ongoingSelection = false

onready var options = $Options
onready var playerChoice = $PlayerChoice
var onlyOneOption = false  ##Disables any movement

var selectableChoices = []
var typeOfSubMenu
signal selected

func set_choices(itemType):
	if itemType == "golem":
		typeOfSubMenu = PARTY
		set_part_sub ()
	else:
		typeOfSubMenu = ITEM
	for i in playerChoice.get_child_count():
		if i == MOVE:
			selectableChoices.append(true)
		elif i== USE and typeOfSubMenu == PARTY:
			selectableChoices.append(true)
		elif i == USE:
			if ItemTable.UseItemList.has(itemType):
				selectableChoices.append(true)
			else:
				selectableChoices.append(false)
		elif i == DISCARD and itemType != null:
			selectableChoices.append(true)
		
		elif itemType != null and typeOfSubMenu != PARTY:
			selectableChoices.append(true)
		else:
			selectableChoices.append(false)
			
			
	###Determining what gets displayed as selectable or not. Option 5 is View, 
	###so the number count for i is altered based on what's being displayes
	for i in playerChoice.get_child_count():
		if !selectableChoices[i]:
			if typeOfSubMenu == PARTY and i >= 1:
				options.get_child(i+1).get_child(0).add_color_override("font_color", Color("adadad"))
			elif typeOfSubMenu == ITEM and i >= 2:
				options.get_child(i+1).get_child(0).add_color_override("font_color", Color("adadad"))
			else:
				options.get_child(i).get_child(0).add_color_override("font_color", Color("adadad"))

func set_part_sub ():
	$Options/Option5.show()
	$Options/Option2.hide()
# Called when the node enters the scene tree for the first time.
func _ready():
	update_selection()
	pass # Replace with function body.

func select():
	if typeOfSubMenu == PARTY and currentPlayerSelection == USE:
		currentPlayerSelection = VIEW
	emit_signal("selected",currentPlayerSelection)
	if currentPlayerSelection == MOVE:
		ongoingSelection = true
		self.hide()
	elif currentPlayerSelection == USE:
		ongoingSelection = true
		self.hide()
	elif currentPlayerSelection == DISCARD:
		ongoingSelection = true
		self.hide()
	else: queue_free()
func wake():
	self.show()
	ongoingSelection = false
	
func cancel():
	if ongoingSelection:
		wake()
	else: self.queue_free()
func move_down():
	var foundNextSelection = false
	while !foundNextSelection:
		currentPlayerSelection += 1
		if currentPlayerSelection >= playerChoice.get_child_count():
			currentPlayerSelection = 0
		if selectableChoices[currentPlayerSelection]:
			foundNextSelection = true
	update_selection()
func move_up():
	var foundNextSelection = false
	while !foundNextSelection:
		currentPlayerSelection -= 1
		if currentPlayerSelection < 0:
			currentPlayerSelection = playerChoice.get_child_count()-1
		
		if selectableChoices[currentPlayerSelection]:
			foundNextSelection = true
	update_selection()

func update_selection():
	for i in playerChoice.get_child_count():
		if i == currentPlayerSelection:
			playerChoice.get_child(i).modulate.a = 1.0
		else:playerChoice.get_child(i).modulate.a = 0.0
	
	pass
