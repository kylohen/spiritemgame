extends Node

##Play state helps define what's going on in the game, 
##allowing for scenes to overlap eachother if needed
enum PLAYSTATE {GAME,MENU,PAUSE}

enum TOOLS {PICKAXE,AXE,SHOVEL,SCYTHE}
var toolSelected
var currentPLAYSTATE


func _ready():
	currentPLAYSTATE = PLAYSTATE.GAME
	pass # Replace with function body.

## updates the selected tool to the new tool provided
func update_tool (newTool) -> void:
	toolSelected = newTool

##Checks if game is in the play state and returns a bool
func is_PLAYSTATE(state)->bool:
	if currentPLAYSTATE == state:
		return true
	return false
