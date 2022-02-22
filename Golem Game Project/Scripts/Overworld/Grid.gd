extends Node2D
##Grid is used to both generate the map and allows the player to interact with what is on the world
onready var overworld = $Overworld
onready var interactOverlay = $InteractOverlay
onready var player = $Player

const TILE_SIZE = 24

onready var overworldObjectScene = preload("res://Scenes/Overworld/OverworldObjects.tscn")
onready var lootItemScene = preload("res://Scenes/Overworld/LootItem.tscn")

var gridMap = []
var objectPlacement = []
export (int) var gridWidth  = 25
export (int) var gridHeight = 25

enum tileTypes {grass,grassCorner,wall} ##Should match up with the tiletypes and will need to be updated on spriteUpdate
enum objectTypes {TallGrass,Boulders,Logs}
enum direction {Up,Right,Down,Left}

signal loot_received
## Game world runs in this script, responsible for checking against player location/object location

var golemRecipes= {
	"StrawBoy" : {
		"Straw" : 4
	}
}
func _ready():
	initialize_gridMap()
	initialize_objectPlacement()
	build_border()
	build_terrain()
	randomize_Objects()
	pass
	
## called on startup to generate an empty array to fill up for gridMap
func initialize_gridMap(width = gridWidth,height = gridHeight) -> void:
	gridMap = new_grid_array(width,height)
	
## called on startup to generate an empty array to fill up for gridMap
func initialize_objectPlacement(width = gridWidth,height = gridHeight) -> void:
	objectPlacement = new_grid_array(width,height)
	
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
				gridMap[x][y] =tileTypes.wall
			elif y == 0 or y == height-1:
				overworld.set_cell(x,y,tileTypes.wall)
				objectPlacement[x][y] = tileTypes.wall
				gridMap[x][y] =tileTypes.wall

func build_terrain():
	for x in gridMap.size():
		for y in gridMap[x].size():
			if !(gridMap[x][y] is int): 
				##insert logic for tile filling open space
				overworld.set_cell(x,y,tileTypes.grass)
				gridMap[x][y] = tileTypes.grass
				
## checks to see if there is something in the grid, if there is, return false
func is_Open_Tile(currentPosition, directionToGo) -> bool:
	var newPosition = currentPosition + directionToGo
	var block = objectPlacement[newPosition.x][newPosition.y]
	if block != null:
		if !(block is int):##Walls and other impassable and immutable terrain is stored as ints
			if block.type == "object":
				return objectPlacement[newPosition.x][newPosition.y].is_passable()
			if block.type == "loot":
				emit_signal("loot_received",block.itemID, block.quantity)
				block.queue_free()
				objectPlacement[newPosition.x].remove(newPosition.y)
				objectPlacement[newPosition.x].insert(newPosition.y,null)
			return true
		return false
	return true

func randomize_Objects():
	var ratesOfSpawning = [0.02,0.02,0.02]
	for x in objectPlacement.size():
		for y in objectPlacement[x].size():
			if Vector2(x,y) != player.gridCoords and !(objectPlacement[x][y] is int):
				var rollForItem = SeedGenerator.rng.randf_range(0,1)
				var currentChance = 0.0
				for i in ratesOfSpawning.size():
					if rollForItem <currentChance+ratesOfSpawning[i] and rollForItem > currentChance:
						objectPlacement[x][y] = spawn_object(i,Vector2(x,y))
						break
					currentChance += ratesOfSpawning[i]
						
func spawn_object (objectToSpawn, pos):
	var newObject = overworldObjectScene.instance()
	newObject.position = pos*TILE_SIZE
	interactOverlay.add_child(newObject)
	
	newObject.spawn_object(objectToSpawn)
	return newObject


func _on_Player_useToolOnBlock(blockToCheck):
	var block = objectPlacement[blockToCheck.x][blockToCheck.y]
	if block is Node2D:
		if block.toolUsed():
			var objectDestroyed = block.objectSelected
			block.queue_free()
			objectPlacement[blockToCheck.x].remove(blockToCheck.y)
			objectPlacement[blockToCheck.x].insert(blockToCheck.y,null)
			
			####################
#			Insert Function to run a full Loot Table
			#####################
			
			#####################
#			Remove the below:
			var listOfPossibleItems = WorldConductor.lootTable[objectDestroyed].keys()
			
			var lootType = listOfPossibleItems[0]
			var quantityOfLoot = SeedGenerator.rng.randi_range(WorldConductor.lootTable[objectDestroyed][lootType]["min"],WorldConductor.lootTable[objectDestroyed][lootType]["max"])
			#####################
			
			emit_signal("loot_received",lootType,quantityOfLoot)
			
			
#			block.clear()
#			block.append(null)
#			block.free()
#			remove_child(block)
#			block.queue_free()
			print(block)
	elif blockToCheck == Vector2(13,9):
		print ("Checking Golem")
		golem_checking ()
	pass # Replace with function body.


func _on_Player_useItemOnBlock(itemID,itemTexture,blockToCheck):
	var block = objectPlacement[blockToCheck.x][blockToCheck.y]
	if !(block is Node2D):
		var newLoot = lootItemScene.instance()
		objectPlacement[blockToCheck.x].insert(blockToCheck.y,newLoot)
		newLoot.position = Vector2(blockToCheck.x,blockToCheck.y)*TILE_SIZE
		interactOverlay.add_child(newLoot)
		newLoot.set_loot(itemID,itemTexture)

func golem_checking ():
	var locations = [Vector2(14,7),Vector2(15,8),Vector2(15,10),Vector2(14,11),Vector2(12,11),Vector2(11,10),Vector2(11,8),Vector2(12,7)]
	var itemsFound = {}
	for i in locations.size():
		var object = objectPlacement[locations[i].x][locations[i].y]
		if object is Node2D:
			if object.type == "loot":
				if itemsFound.has(object.itemID):
					itemsFound[object.itemID] += 1
				else:itemsFound[object.itemID] = 1
	var keys = golemRecipes.keys()
	for i in keys.size():
		var hasEverything = true
		var recipeItems = golemRecipes[keys[i]].keys()
		for j in recipeItems.size():
			if !itemsFound.has(recipeItems[j]):
				hasEverything = false
			elif golemRecipes[keys[i]][recipeItems[j]]>itemsFound[recipeItems[j]]:
				hasEverything = false
		if hasEverything:
			print ("ITS ALIVE! ",keys[i]," IS ALIVE")
			take_golem_items()
			$AnimationPlayer.play("GolemSpawning")
	print (itemsFound)
	
func take_golem_items():
	var locations = [Vector2(14,7),Vector2(15,8),Vector2(15,10),Vector2(14,11),Vector2(12,11),Vector2(11,10),Vector2(11,8),Vector2(12,7)]
	for i in locations.size():
		var object = objectPlacement[locations[i].x][locations[i].y]
		if object is Node2D:
			object.queue_free()
			objectPlacement[locations[i].x].remove(locations[i].y)
			objectPlacement[locations[i].x].insert(locations[i].y,null)
	pass
