extends Node
## Conductor helps advise the other nodes of the objects in the world

const TILE_SIZE = 24

enum objectTypes {TallGrass,Boulders,Trees,Logs,Clay}
var objectTextures = {
	objectTypes.TallGrass : "res://Assets/OverworldObjects/sprite_overworld_grass_stage2.png",
	objectTypes.Boulders : "res://Assets/OverworldObjects/sprite_overworld_boulder.png",
	objectTypes.Logs : "res://Assets/OverworldObjects/sprite_overworld_log_stage0.png",
	objectTypes.Trees : "res://Assets/OverworldObjects/sprite__overworld_harvestable_rubber.png",
	objectTypes.Clay : "res://Assets/OverworldObjects/sprite_overworld_clay_stage1.png"
}
onready var overworldObject = {
	objectTypes.TallGrass:{
		"passable" : true,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.SCYTHE
		},
	objectTypes.Boulders:{
		"passable" : false,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.PICKAXE
		},
	objectTypes.Logs :{
		"passable" : false,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.AXE
		},
	objectTypes.Trees:{
		"passable" : false,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.AXE
		},
	objectTypes.Clay :{
		"passable" : true,
		"lootTable" : "",
		"toolUse": GlobalPlayer.TOOLS.SHOVEL
		}
	}

onready var lootTable = {
	objectTypes.TallGrass:{
		"Straw":{
			"min":1,
			"max":3
			}
		},
	objectTypes.Boulders:{
		"Rock":{
			"min":1,
			"max":3
			}
		},
	objectTypes.Clay:{
		"Clay":{
			"min":1,
			"max":3
			}
		},
	objectTypes.Logs:{
		"Wood":{
			"min":1,
			"max":2
			}
		},
	objectTypes.Trees:{
		"Wood":{
			"min":1,
			"max":5
			}
		},
		
}
func test():
	var pull = lootTable[0].keys()
	pass
