extends Control

signal buttonMoveAudio
onready var selectionUI = {
	"Slot1" : $SelectionUI/LeftColumn/Slot1,
	"Slot2" : $SelectionUI/RightColum/Slot2,
	"Slot3" : $SelectionUI/RightColum/Slot3,
	"Slot4" : $SelectionUI/LeftColumn/Slot4
}
onready var toolSelection ={
	"Slot1" : $ToolImageUI/LeftColumn/Slot1,
	"Slot2" : $ToolImageUI/RightColum/Slot2,
	"Slot3" : $ToolImageUI/RightColum/Slot3,
	"Slot4" : $ToolImageUI/LeftColumn/Slot4,
}
onready var arrowSelectImage = $ArrowSelection


var selectedOpacity = 128
var notSelectedOpacity = 0
onready var toolSelected = GlobalPlayer.toolSelected
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_selection_Highlight(toolSelected)
	var rotateDegree = 0
	if toolSelected > 0:
		for i in toolSelected:
			rotateDegree += 90
	rotate_dial(rotateDegree)
	pass # Replace with function body.

##Should only be passing 90 degree increments
func rotate_dial(rotationDegree):
	var newRotation = arrowSelectImage.rect_rotation + rotationDegree
	if newRotation > 360:
		arrowSelectImage.rect_rotation = rotationDegree
	elif newRotation < -360 :
		arrowSelectImage.rect_rotation = rotationDegree
	else:
		arrowSelectImage.rect_rotation = newRotation
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_selection_Highlight(newChoice):
	GlobalPlayer.update_tool(newChoice)
	turn_off_all_selected()
	var keys = selectionUI.keys()
	selectionUI[keys[newChoice]].modulate.a8 = selectedOpacity
	pass
func turn_off_all_selected():
	var keys = selectionUI.keys()
	var size = keys.size()
	for i in size:
		selectionUI[keys[i]].modulate.a8 = notSelectedOpacity
		
func _on_PlayerUI_nextTool():
	toolSelected += 1
	if toolSelected > GlobalPlayer.TOOLS.size()-1:
		toolSelected = 0
	set_selection_Highlight(toolSelected)
	rotate_dial(90)
	emit_signal("buttonMoveAudio")


func _on_PlayerUI_previousTool():
	toolSelected -= 1
	if toolSelected < 0:
		toolSelected = GlobalPlayer.TOOLS.size()-1
	set_selection_Highlight(toolSelected)
	rotate_dial(-90)
	emit_signal("buttonMoveAudio")
