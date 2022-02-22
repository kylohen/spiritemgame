extends Node2D
var type = "object"
onready var objectSprite = $Object
var objectSelected
var objectTextures = {
	WorldConductor.objectTypes.TallGrass : "res://Assets/OverworldObjects/TallGrass.png",
	WorldConductor.objectTypes.Boulders : "res://Assets/OverworldObjects/Boulder.png",
	WorldConductor.objectTypes.Logs : "res://Assets/OverworldObjects/Wood.png"
}

onready var overworldObject = {
	WorldConductor.objectTypes.TallGrass:{
		"passable" : true,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.SCYTHE
		},
	WorldConductor.objectTypes.Boulders:{
		"passable" : false,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.PICKAXE
		},
	WorldConductor.objectTypes.Logs :{
		"passable" : false,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.AXE
		}
	}



func _ready():
	pass
	
func spawn_object(objectToSpawn):
	objectSprite.texture = load(objectTextures[objectToSpawn])
	objectSelected = objectToSpawn
	
func is_passable():
	if objectSelected != null:
		return overworldObject[objectSelected]["passable"]
		
func toolUsed():
	if GlobalPlayer.toolSelected == overworldObject[objectSelected]["toolUse"]:
		##Insert logic to include giving items/loot table
		return true
	return false
