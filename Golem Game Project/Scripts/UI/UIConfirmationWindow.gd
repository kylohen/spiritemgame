extends Control


#signal buttonSelectAudio
#signal buttonMoveAudio
signal buttonPressed

var playerCurrentSelection = 0

onready var yesChoice = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Choice1
onready var noChoice = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Choice2

func _ready():
	update_player_selection()
	
func move_right():
	playerCurrentSelection += 1
	if playerCurrentSelection > 1:
		playerCurrentSelection = 0
	update_player_selection()
func move_left():
	playerCurrentSelection -= 1
	if playerCurrentSelection < 0:
		playerCurrentSelection = 1
	update_player_selection()
func selected():
	if playerCurrentSelection ==0:
		_on_Yes_pressed()
	elif playerCurrentSelection == 1:
		_on_No_pressed()
func cancel():
	emit_signal("buttonPressed",false)
#	emit_signal("buttonSelectAudio")
	self.queue_free()
	

func update_player_selection():
	if playerCurrentSelection ==0:
		yesChoice.modulate.a = 1.0
		noChoice.modulate.a = 0.0
		
	elif playerCurrentSelection ==1:
		yesChoice.modulate.a = 0.0
		noChoice.modulate.a = 1.0
	
#	emit_signal("buttonMoveAudio")


func _on_No_pressed():
	emit_signal("buttonPressed",false)
#	emit_signal("buttonSelectAudio")
	self.queue_free()
	pass # Replace with function body.


func _on_Yes_pressed():
	emit_signal("buttonPressed",true)
#	emit_signal("buttonSelectAudio")
	self.queue_free()
	pass # Replace with function body.
