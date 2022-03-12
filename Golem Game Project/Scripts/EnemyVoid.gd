extends AStar_Path


var currentGridPosition :Vector2
var isElite = false
var enemyID = 0
var statBlock = {}
var statBlockBack = {}
var enemyName = ""
var enemyBackName = ""
var enemyType = ""
signal touch_player

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = currentGridPosition*WorldConductor.TILE_SIZE
	pass # Replace with function body.

func spawn_enemy(newEnemyID, newEnemyIDBack = -1):
	statBlock = StatBlocks.enemyStatBlocks[newEnemyID]
	enemyName = statBlock["NAME"]
#	statBlock["CURRENT ACTION"] = statBlock["ACTION METER"]
#	statBlock["CURRENT MAGIC"] = statBlock["MAGIC METER"]
	statBlock["CURRENT HP"] = statBlock["HP"]
	if newEnemyIDBack != -1:
		statBlockBack = StatBlocks.enemyStatBlocks[newEnemyIDBack]
		enemyBackName = statBlock["NAME"]
		statBlockBack["CURRENT HP"] = statBlock["HP"]
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func move_enemy(playerPositionInGrid):
	_get_path(currentGridPosition,playerPositionInGrid)
	print (path)
	if !path.empty():
		currentGridPosition = path[0]
		self.position = path[0]*WorldConductor.TILE_SIZE
	else:
		set_grid(get_parent().get_parent().gridMap,get_parent().get_parent().objectPlacement,get_parent().get_parent().gridWidth,get_parent().get_parent().gridHeight)
		currentGridPosition = path[0]
		self.position = path[0]*WorldConductor.TILE_SIZE

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("touch_player",self)
	pass # Replace with function body.
