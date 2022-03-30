extends Control
enum {MOVE,USE,PLACE,DISCARD,VIEW}
enum {ITEM,PARTY}
var currentPlayerSelection = 0
var ongoingSelection = false

onready var options = $Options
onready var playerChoice = $PlayerChoice

var typeOfSubMenu
var onlyOneOption = false  ##Disables any movement

var selectableChoices = []

signal selected

func set_choices(itemType):
	for i in playerChoice.get_child_count():
		if i == MOVE:
			selectableChoices.append(MOVE)
		if itemType == "golem":
			typeOfSubMenu = PARTY
			set_part_sub ()
#			if i == USE:
			if LootTable.UseItemList.has(itemType):
				selectableChoices.append(USE)
		if itemType != null:
			selectableChoices.append(i)
	for i in options.get_child_count():
		if !selectableChoices.has(i):
			options.get_child(i).get_child(0).add_color_override("font_color", Color("adadad"))

func set_part_sub ():
	$Options/Option5.show()
	$Options/Option2.hide()
func _ready():
	update_selection()
	pass # Replace with function body.

func select():
#	if
	emit_signal("selected",currentPlayerSelection)
	if currentPlayerSelection == MOVE:
		ongoingSelection = true
		self.hide()
	else: queue_free()
func cancel():
	if ongoingSelection:
		self.show()
		ongoingSelection = false
	else: self.queue_free()
func move_down():
	var foundNextSelection = false
	while !foundNextSelection:
		currentPlayerSelection += 1
		if currentPlayerSelection >= options.get_child_count():
			currentPlayerSelection = 0
		if selectableChoices.has(currentPlayerSelection):
			foundNextSelection = true
	update_selection()
func move_up():
	var foundNextSelection = false
	while !foundNextSelection:
		currentPlayerSelection -= 1
		if currentPlayerSelection < 0:
			currentPlayerSelection = options.get_child_count()-1
		
		if selectableChoices.has(currentPlayerSelection):
			foundNextSelection = true
	update_selection()

func update_selection():
	for i in playerChoice.get_child_count():
		if i == currentPlayerSelection:
			playerChoice.get_child(i).modulate.a = 1.0
		else:playerChoice.get_child(i).modulate.a = 0.0
	
	pass

