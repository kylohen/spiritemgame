extends Node2D
var type = "object"
onready var objectSprite = $Object
var objectSelected

onready var respawnTimer = $RespawnTimer

var isPassable
var active = true

func _ready():
	pass
	
func spawn_object(objectToSpawn):
	objectSprite.texture = load(WorldConductor.objectTextures[objectToSpawn])
	objectSelected = objectToSpawn
	isPassable = WorldConductor.overworldObject[objectSelected]["passable"]
	
func is_passable():
	if objectSelected != null:
		return isPassable
		
func toolUsed():
	if GlobalPlayer.toolSelected == WorldConductor.overworldObject[objectSelected]["toolUse"] and active:
		##Insert logic to include giving items/loot table
		self.modulate.a = 0.0
		isPassable = true
		respawnTimer.start()
		active = false
		return true
	return false



func _on_RespawnTimer_timeout():
	self.modulate.a = 1.0
	isPassable = WorldConductor.overworldObject[objectSelected]["passable"]
	active = true
	pass # Replace with function body.
