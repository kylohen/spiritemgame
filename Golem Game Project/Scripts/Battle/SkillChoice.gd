extends Control
onready var skillNameNode = $MarginContainer/HBoxContainer/SkillName

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
	skillNumber = newSkillNumber
	skillDetails = StatBlocks.skillList[skillNumber]
	skillName = skillDetails["NAME"]
	skillNameNode.text = skillName

func main_menu(newText):
	skillName = null
	skillDetails = null
	skillNumber = null
	skillNameNode.text = newText

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
