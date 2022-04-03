extends AStar_Path

onready var collision = $Area2D
onready var voidMovement = $VoidMovement
onready var voidSpawn = $VoidSpawn

var currentGridPosition :Vector2
var isElite = false
var enemyID = 0
var statBlock = {}
var statBlockBack = {}
var enemyName = ""
var enemyBackName = ""
var enemyType = ""
signal touch_player

enum {NORTH,EAST,SOUTH,WEST}
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
		enemyBackName = statBlockBack["NAME"]
		statBlockBack["CURRENT HP"] = statBlockBack["HP"]
	
	if GlobalPlayer.levelOfCave >=2:
		statBlock = StatBlocks.scale_up(statBlock,GlobalPlayer.levelOfCave)
		statBlockBack = StatBlocks.scale_up(statBlockBack,GlobalPlayer.levelOfCave)
	voidSpawn.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func move_enemy(playerPositionInGrid):
	_get_path(currentGridPosition,playerPositionInGrid)
#	print (path)
	if !path.empty():
		currentGridPosition = path[0]
		self.position = currentGridPosition*WorldConductor.TILE_SIZE
		
	else:
		set_grid(get_parent().get_parent().gridMap,get_parent().get_parent().objectPlacement,get_parent().get_parent().gridWidth,get_parent().get_parent().gridHeight)
		if path.empty():
			currentGridPosition += random_move()
		else: currentGridPosition = path[0]
		self.position = currentGridPosition*WorldConductor.TILE_SIZE
	voidMovement.play()

func random_move():
	var directions = [Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT]
	var chosenOptions
	for i in range (directions.size()-1,-1,-1):
		var rollChoice = SeedGenerator.rng.randi_range(0,i)
		var randDirection = directions[rollChoice]
		if get_parent().get_parent().is_Open_Tile(currentGridPosition,randDirection,false):
			return randDirection
		directions.erase(randDirection)
	return Vector2.ZERO
			
		
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("touch_player",self)
	pass # Replace with function body.
	
func disable():
	collision.monitoring = false
func enable():
	collision.monitoring = true
