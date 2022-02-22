extends Control

var currentPlayerSelection = 0
var ongoingSelection = false

onready var options = $Options
onready var playerChoice = $PlayerChoice

var onlyOneOption = false

signal selected

func set_choices(hasItemInSlot):
	if !hasItemInSlot:
		for i in playerChoice.get_child_count():
			if i == 0:
				pass
			else:playerChoice.get_child(i).queue_free()
		for i in options.get_child_count():
			if i == 0:
				pass
			else:options.get_child(i).get_child(0).add_color_override("font_color", Color("adadad"))
		onlyOneOption = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	update_selection()
	pass # Replace with function body.

func select():
	emit_signal("selected",currentPlayerSelection)
	if currentPlayerSelection == 0:
		ongoingSelection = true
		self.hide()
	else: queue_free()
func cancel():
	if ongoingSelection:
		self.show()
		ongoingSelection = false
	else: self.queue_free()
func move_down():
	if !onlyOneOption:
		currentPlayerSelection += 1
		if currentPlayerSelection > options.get_child_count()-1:
			currentPlayerSelection = 0
		update_selection()
func move_up():
	if !onlyOneOption:
		currentPlayerSelection -= 1
		if currentPlayerSelection < 0:
			currentPlayerSelection = options.get_child_count()-1
		update_selection()

func update_selection():
	for i in playerChoice.get_child_count():
		if i == currentPlayerSelection:
			playerChoice.get_child(i).modulate.a = 1.0
		else:playerChoice.get_child(i).modulate.a = 0.0
	
	pass

