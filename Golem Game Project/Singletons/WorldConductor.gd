extends Node
## Conductor helps advise the other nodes of the objects in the world
enum objectTypes {TallGrass,Boulders,Logs}

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
	objectTypes.Logs:{
		"Wood":{
			"min":1,
			"max":3
			}
		},
		
}
func test():
	var pull = lootTable[0].keys()
	pass
