extends Node2D
var type = "object"
onready var objectSprite = $Object
var objectSelected






func _ready():
	pass
	
func spawn_object(objectToSpawn):
	objectSprite.texture = load(WorldConductor.objectTextures[objectToSpawn])
	objectSelected = objectToSpawn
	
func is_passable():
	if objectSelected != null:
		return WorldConductor.overworldObject[objectSelected]["passable"]
		
func toolUsed():
	if GlobalPlayer.toolSelected == WorldConductor.overworldObject[objectSelected]["toolUse"]:
		##Insert logic to include giving items/loot table
		return true
	return false
