extends Node2D
##Grid is used to both generate the map and allows the player to interact with what is on the world
onready var overworld = $Overworld
onready var interactOverlay = $InteractOverlay
onready var player = $Player
onready var sceneTransitions = $Camera2D/SceneTransitions
onready var itemDrop = $ItemDrops

const TILE_SIZE = 24

onready var overworldObjectScene = preload("res://Scenes/Overworld/OverworldObjects.tscn")
onready var lootItemScene = preload("res://Scenes/Overworld/LootItem.tscn")

signal leave_cave
signal new_level_cave
var gridMap = []
var objectPlacement = []
var itemDropPlacement = []
export (int) var gridWidth  = 35
export (int) var gridHeight = 35
var arrayOfBoulders = []
var arrayOfStairs = []
var leaveCave = Vector2(1,0)
enum tileTypes {water,sand,clay,grass,trees,rocks,wall} ##Should match up with the tiletypes and will need to be updated on spriteUpdate
var tileTypeDict = {
	tileTypes.water : 5,
	tileTypes.sand :6,
	tileTypes.clay : 7,
	tileTypes.grass: 0,
	tileTypes.trees: 8,
	tileTypes.rocks: 9,
	tileTypes.wall:10
}
onready var stairsTile = 11
onready var objectTypePerTileTypeDict ={
	tileTypes.water : [],
	tileTypes.sand :[],
	tileTypes.clay : [WorldConductor.objectTypes.Clay],
	tileTypes.grass: [WorldConductor.objectTypes.TallGrass],
	tileTypes.trees: [WorldConductor.objectTypes.Logs,WorldConductor.objectTypes.Trees],
	tileTypes.rocks: [WorldConductor.objectTypes.Boulders],
	tileTypes.wall:[]
}
var noise = OpenSimplexNoise.new()

##Object Types stored in WorldConductor
#enum objectTypes {TallGrass,Boulders,Trees,Logs,Clay} 
enum direction {Up,Right,Down,Left}


signal loot_received

var whatToDoAfterTransition = null
## Game world runs in this script, responsible for checking against player location/object location


func _ready():
	initialize_gridMap()
	initialize_objectPlacement()
	initialize_itemDropPlacement()
	overworld.set_cell(0,1,12)
	
	build_border()
	build_terrain()
	build_stairs()
#	randomize_Objects()
	sceneTransitions.run_Transition("radial_wipe_on")
	pass
	
## called on startup to generate an empty array to fill up for gridMap
func initialize_gridMap(width = gridWidth,height = gridHeight) -> void:
	gridMap = new_grid_array(width,height)
	
## called on startup to generate an empty array to fill up for gridMap
func initialize_objectPlacement(width = gridWidth,height = gridHeight) -> void:
	objectPlacement = new_grid_array(width,height)
	
func initialize_itemDropPlacement(width = gridWidth,height = gridHeight) -> void:
	itemDropPlacement = new_grid_array(width,height)
## return an empty grid with width and height
func new_grid_array(width,height) -> Array:
	var newGridArray = []
	for x in width:
		newGridArray.append([])
		for y in height:
			newGridArray[x].append(null)
	return newGridArray

## takes some basic logic to build a border wall. Can disable the tilemapping or in the future
## change the different types of sprites
func build_border(width = gridWidth,height = gridHeight):
	for x in width:
		for y in height:
			if x == 0 or x == width-1:
				overworld.set_cell(x,y,tileTypes.wall)
				objectPlacement[x][y] = tileTypes.wall
				gridMap[x][y] =tileTypeDict[tileTypes.wall]
			elif y == 0 or y == height-1:
				overworld.set_cell(x,y,tileTypes.wall)
				objectPlacement[x][y] = tileTypes.wall
				gridMap[x][y] =tileTypeDict[tileTypes.wall]

func build_terrain():
	for x in gridMap.size():
		for y in gridMap[x].size():
			if !(gridMap[x][y] is int): 
				##insert logic for tile filling open space
#				gridMap[x][y] = spawnTerrainTile(x,y)
				var selectedTile = tileTypes.rocks
				gridMap[x][y] = selectedTile
				
				chanceOfSpawningResource(x,y,selectedTile)
#		print(gridMap[x])

func makingNoise ():

# Configure
	noise.seed = SeedGenerator.rng.randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
func spawnTerrainTile (x,y):
	var randomTile = noise.get_noise_2d(x,y)
	var selectedTile = null
	if randomTile < -0.45:
		selectedTile = tileTypes.water
	elif randomTile < -0.4:
		selectedTile = tileTypes.sand
	elif randomTile <-0.37:
		selectedTile = tileTypes.clay
	elif randomTile <0.3:
		selectedTile = tileTypes.grass
	elif randomTile <0.4:
		selectedTile = tileTypes.trees
	elif randomTile <1:
		selectedTile = tileTypes.rocks
	else:
		selectedTile = tileTypes.grass
	
	if selectedTile != null:
		overworld.set_cell(x,y,tileTypeDict[selectedTile])
		if selectedTile == tileTypes.water:
			objectPlacement[x][y] = tileTypes.water
		chanceOfSpawningResource(x,y,selectedTile)
	
	return selectedTile

func chanceOfSpawningResource(x,y,selectedTile):
	var chanceOfSpawn = 0.20 # 20% spawn chance
	var objectPossibleSpawns = objectTypePerTileTypeDict[selectedTile]
	if !objectPossibleSpawns.empty():
		for i in objectPossibleSpawns.size():
			var rollForItem = SeedGenerator.rng.randf_range(0,1)
			if rollForItem <chanceOfSpawn:
				objectPlacement[x][y] = spawn_object(objectPossibleSpawns[i],Vector2(x,y))
				break


## checks to see if there is something in the grid, if there is, return false
func is_Open_Tile(currentPosition, directionToGo,isPlayer=true) -> bool:
	var newPosition = currentPosition + directionToGo
	var block = objectPlacement[newPosition.x][newPosition.y]
	var itemCheck = itemDropPlacement[newPosition.x][newPosition.y]
	if isPlayer:
		pickUpItem(itemCheck,newPosition)
		if arrayOfStairs.has(newPosition):
			whatToDoAfterTransition  = "Cave Load"
			sceneTransitions.run_Transition("radial_wipe_off")
		elif newPosition == leaveCave:
			
			whatToDoAfterTransition = "Leave Cave"
			sceneTransitions.run_Transition("radial_wipe_off")
	if block != null:
		if !(block is int):##Walls and other impassable and immutable terrain is stored as ints
			
			if block.type == "Resource":
				return objectPlacement[newPosition.x][newPosition.y].is_passable()
			elif block.type == "loot":
				emit_signal("loot_received",block.itemID, block.quantity)
				block.queue_free()
				objectPlacement[newPosition.x].remove(newPosition.y)
				objectPlacement[newPosition.x].insert(newPosition.y,null)
			
				
			return true
		return false
	return true


func pickUpItem(item,newPosition):
	if item != null:
		if item.type == "loot":
			emit_signal("loot_received",item.itemID, item.quantity)
			item.queue_free()
			itemDropPlacement[newPosition.x].remove(newPosition.y)
			itemDropPlacement[newPosition.x].insert(newPosition.y,null)

func new_cave():
	emit_signal("new_level_cave")
	GlobalPlayer.Go_Down_A_Level()
	queue_free()
func exit_cave():
	emit_signal("leave_cave")
	queue_free()
func build_stairs(stairCount = 2):
	for i in stairCount:
		var randomChoice = SeedGenerator.rng.randi_range(0,arrayOfBoulders.size()-1)
		var selectedPos = arrayOfBoulders[randomChoice]
		overworld.set_cell(selectedPos.x,selectedPos.y,stairsTile)
		arrayOfStairs.append(selectedPos)


func spawn_object (objectToSpawn, pos):
	var newObject = overworldObjectScene.instance()
	newObject.position = pos*TILE_SIZE
	interactOverlay.add_child(newObject)
	
	newObject.spawn_object(objectToSpawn)
	arrayOfBoulders.append(pos)
	return newObject

func _on_Player_useToolOnBlock(blockToCheck):
	var block = objectPlacement[blockToCheck.x][blockToCheck.y]
	var item = itemDropPlacement[blockToCheck.x][blockToCheck.y]
	pickUpItem(item,blockToCheck)
	if block is Node2D:
		if block.toolUsed():
			if !(block.objectSelected == WorldConductor.objectTypes.Pedestal or block.objectSelected == WorldConductor.objectTypes.GolemGenerator):
				var objectDestroyed = block.objectSelected
				var listOfPossibleItems = WorldConductor.lootTable[objectDestroyed].keys()
				
				var lootType = listOfPossibleItems[0]
				var quantityOfLoot = SeedGenerator.rng.randi_range(WorldConductor.lootTable[objectDestroyed][lootType]["min"],WorldConductor.lootTable[objectDestroyed][lootType]["max"])
				#####################
				
				emit_signal("loot_received",lootType,quantityOfLoot)



func _on_Player_useItemOnBlock(itemID,itemTexture,blockToCheck,itemIndex):
	var block = objectPlacement[blockToCheck.x][blockToCheck.y]
	var itemDropSpot = itemDropPlacement[blockToCheck.x][blockToCheck.y]
	var canPlayerDrop = false
	if !(itemDropSpot is Node2D):
		if !(block is Node2D):
			canPlayerDrop = true
		elif (block is Node2D):
			if block.objectSelected == WorldConductor.objectTypes.Pedestal:
				canPlayerDrop = true
	if canPlayerDrop:
		var newLoot = lootItemScene.instance()
		itemDropPlacement[blockToCheck.x].insert(blockToCheck.y,newLoot)
		newLoot.position = Vector2(blockToCheck.x,blockToCheck.y)*TILE_SIZE
		itemDrop.add_child(newLoot)
		newLoot.set_loot(itemID,itemTexture)
		GlobalPlayer.use_item(itemID,itemIndex)

	

func _on_SceneTransitions_transitionDone(transitionAnimation):
	if transitionAnimation == "radial_wipe_off":
		if whatToDoAfterTransition == "Cave Load":
			new_cave()
		elif whatToDoAfterTransition == "Leave Cave":
			exit_cave()
	pass # Replace with function body.
