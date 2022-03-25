extends Control
onready var skillNameNode = $MarginContainer/HBoxContainer/SkillName
onready var backingImageNode = $MarginContainer/SlotBackground
onready var skillPictureNode = $MarginContainer/HBoxContainer/SkillPicture
onready var partySlotMemberNode = $MarginContainer/PartySlotUI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var skillName
var skillDetails
var skillNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_skill(newSkillNumber):
	if newSkillNumber != null:
		skillNumber = newSkillNumber
		skillDetails = StatBlocks.skillList[skillNumber]
		skillName = skillDetails["NAME"]
	else:
		skillName ="NONE"
	
	skillNameNode.text = skillName

func not_enough_energy():
	skillNameNode.set("custom_colors/font_color", Color(.75,.75,.75,1.0))

func main_menu(newText):
	reset()
	skillNameNode.text = newText

func side_menu(newText):
	reset()
	skillNameNode.text = newText
	backingImageNode.modulate = Color("75b4ff")
	if newText == "None":
		not_enough_energy()

func reset():
	skillName = null
	skillDetails = null
	skillNumber = null
	skillNameNode.set("custom_colors/font_color", Color(0,0,0,1))
	backingImageNode.modulate = Color("ffffff")
	partySlotMemberNode.modulate = Color(1,1,1,1)
	partySlotMemberNode.hide()
	
	
func set_golem(golem,selectable = true):
	reset()
	partySlotMemberNode.show()
	partySlotMemberNode.load_golem(golem)
	if !selectable:
		partySlotMemberNode.modulate = Color(.75,.75,.75,1.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
