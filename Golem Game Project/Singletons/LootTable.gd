extends Node

onready var UseItemList = {
	"Rusty Magic Hammer" :{
		"USE":"Golem",
		"STAT":"CURRENT HP",
		"MODIFIERS": 25,
		"TARGET":StatBlocks.TARGET.BOTH,
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
