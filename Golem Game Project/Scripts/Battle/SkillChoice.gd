extends Control
onready var skillNameNode = $MarginContainer/HBoxContainer/SkillName
onready var backingImageNode = $MarginContainer/SlotBackground
onready var skillPictureNode = $MarginContainer/HBoxContainer/SkillPicture
onready var partySlotMemberNode = $MarginContainer/PartySlotUI
onready var itemSlotNode = $MarginContainer/Item_Choice/InventorySlotUI

onready var itemChoice = $MarginContainer/Item_Choice
onready var itemLabel = $MarginContainer/Item_Choice/Label
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
	itemLabel.set("custom_colors/font_color", Color(0,0,0,1))
	backingImageNode.modulate = Color("ffffff")
	partySlotMemberNode.modulate = Color(1,1,1,1)
	partySlotMemberNode.hide()
	itemSlotNode.modulate = Color(1,1,1,1)
	itemChoice.hide()
	itemSlotNode.reset()
	
	
	
func set_golem(golem,selectable = true):
	reset()
	partySlotMemberNode.show()
	partySlotMemberNode.load_golem(golem)
	if !selectable:
		partySlotMemberNode.modulate = Color(.75,.75,.75,1.0)

func set_item(newItemName=null,newQuantity=null,newIndex=null, selectable = true):
	itemChoice.show()
	itemSlotNode.reset()
	itemLabel.text =""
	if newItemName != null:
		itemLabel.text = newItemName+" x"+str(newQuantity)
		itemSlotNode.set_item(newItemName,newQuantity,newIndex)
	if !selectable:
		itemLabel.set("custom_colors/font_color", Color(.75,.75,.75,1.0))
		itemSlotNode.modulate = Color(.75,.75,.75,1.0)
