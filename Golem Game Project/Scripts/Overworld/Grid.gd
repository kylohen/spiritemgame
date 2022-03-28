extends Node2D
##Grid is used to both generate the map and allows the player to interact with what is on the world
onready var overworld = $Overworld
onready var interactOverlay = $InteractOverlay
onready var itemDrop = $ItemDrops
onready var player = $Player
onready var camera = $Camera2D
onready var playerUI = $Camera2D/PlayerUI
onready var spawnGolem = $SpawnGolem
onready var enemyManager = $EnemyManager
onready var animationPlayer = $AnimationPlayer
onready var sceneTransitions = $Camera2D/SceneTransitions

const TILE_SIZE = 24

onready var overworldObjectScene = preload("res://Scenes/Overworld/OverworldObjects.tscn")
onready var lootItemScene = preload("res://Scenes/Overworld/LootItem.tscn")
onready var caveSystemScene = "res://Scenes/Overworld/CaveSystem.tscn"

var gridMap = []
var objectPlacement = []
var itemDropPlacement = []
export (int) var gridWidth  = 100
export (int) var gridHeight = 100
var caveLocations = []
var isActive = true
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
var previousPosition =Vector2()
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
	
	##Random Generator
	makingNoise ()
	
	build_border()
	build_terrain()
	spawnCave(40)
	enemyManager.spawn_enemy()
	
	##Debug##
	GlobalPlayer.add_golem(SeedGenerator.rng.randi_range(0,StatBlocks.playerGolemBaseStatBlocks.keys().size()-1))
	GlobalPlayer.add_golem(SeedGenerator.rng.randi_range(0,StatBlocks.playerGolemBaseStatBlocks.keys().size()-1))
	GlobalPlayer.add_golem(SeedGenerator.rng.randi_range(0,StatBlocks.playerGolemBaseStatBlocks.keys().size()-1))
	GlobalPlayer.add_golem(SeedGenerator.rng.randi_range(0,StatBlocks.playerGolemBaseStatBlocks.keys().size()-1))
	GlobalPlayer.add_golem(SeedGenerator.rng.randi_range(0,StatBlocks.playerGolemBaseStatBlocks.keys().size()-1))
#	randomize_Objects()
	run_Dialog(DialogStorage.conversation["IntroPart1"])
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
				gridMap[x][y] = spawnTerrainTile(x,y)
		
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
func spawnCave(numberOfCaves = 5):
	for i in numberOfCaves:
		var randomLocation = Vector2(SeedGenerator.rng.randi_range(0,gridWidth),SeedGenerator.rng.randi_range(0,gridHeight))
		overworld.set_cell(randomLocation.x,randomLocation.y,11)
		caveLocations.append(randomLocation)
	
## checks to see if there is something in the grid, if there is, return false
func is_Open_Tile(currentPosition, directionToGo) -> bool:
	var newPosition = currentPosition + directionToGo
	var block = objectPlacement[newPosition.x][newPosition.y]
	var itemCheck = itemDropPlacement[newPosition.x][newPosition.y]
	if caveLocations.has(newPosition):
		sceneTransitions.run_Transition("radial_wipe_off")
		whatToDoAfterTransition = "Cave Load"
		
		
#		previousPosition = player.position
#
#		var newCave = load(caveSystemScene).instance()
#		update_signal_path(newCave)
#
#
##		player.reset_position()
#		add_child(newCave)
#		move_child(newCave,0)
	if itemCheck != null:
			if itemCheck.type == "loot":
				emit_signal("loot_received",itemCheck.itemID, itemCheck.quantity)
				itemCheck.queue_free()
				itemDropPlacement[newPosition.x].remove(newPosition.y)
				itemDropPlacement[newPosition.x].insert(newPosition.y,null)
#		player.check_cave_terrain(true)
#			get_parent().move_child(newCave,0)
	elif block != null:
		if !(block is int):##Walls and other impassable and immutable terrain is stored as ints
			
			
			if block.type == "object":
				return objectPlacement[newPosition.x][newPosition.y].is_passable()
			return true
		return false
	return true


func _on_leave_cave_CaveSystem():
	whatToDoAfterTransition = "Leave Cave"
	isActive = true
	player.changeActiveState(isActive)
	overworld.show()
	interactOverlay.show()
	spawnGolem.show()
	player.show()
	camera.show()
	sceneTransitions.run_Transition("radial_wipe_on")

func exit_cave():
	isActive = true
	player.changeActiveState(isActive)
	overworld.show()
	interactOverlay.show()
	spawnGolem.show()
	player.show()
	camera.show()
#	player.position = previousPosition
#	get_node("Player").connect("useItemOnBlock",self,"_on_Player_useItemOnBlock")
#	get_node("Player").connect("useToolOnBlock",self,"_on_Player_useToolOnBlock")
#	player.update_grid_pos_based_of_pixel_pos (previousPosition)
#	player.emit_signal("newPosForCamera",player.position)
#	player.check_cave_terrain(false)
	
func _on_new_level_cave_CaveSystem():
	isActive = false
	player.changeActiveState(isActive)
	overworld.hide()
	interactOverlay.hide()
	spawnGolem.hide()
	player.hide()
	camera.hide()
	var newCave = load(caveSystemScene).instance()
	update_signal_path(newCave)
	
#	player.reset_position()
	add_child(newCave)
	move_child(newCave,0)
#	player.check_cave_terrain(true)
	
func update_signal_path(newNode:Node2D):
	newNode.connect("leave_cave",self,"_on_leave_cave_CaveSystem")
	newNode.connect("new_level_cave",self,"_on_new_level_cave_CaveSystem")
#	newNode.connect("loot_received",playerUI,"_on_WorldMap_Field_loot_received")
#	newNode.connect("loot_received",player,"_on_WorldMap_Field_loot_received")
##	newNode.get_node("Player").connect("cameraState",camera,"_on_Player_cameraState")
#	get_node("Player").disconnect("useItemOnBlock",self,"_on_Player_useItemOnBlock")
#	get_node("Player").disconnect("useToolOnBlock",self,"_on_Player_useToolOnBlock")
#	get_node("Player").connect("useItemOnBlock",newNode,"_on_Player_useItemOnBlock")
#	get_node("Player").connect("useToolOnBlock",newNode,"_on_Player_useToolOnBlock")
#	pass
#func randomize_Objects():
#	var ratesOfSpawning = [0.02,0.02,0.02]
#	for x in objectPlacement.size():
#		for y in objectPlacement[x].size():
#			if Vector2(x,y) != player.gridCoords and !(objectPlacement[x][y] is int):
#				var rollForItem = SeedGenerator.rng.randf_range(0,1)
#				var currentChance = 0.0
#				for i in ratesOfSpawning.size():
#					if rollForItem <currentChance+ratesOfSpawning[i] and rollForItem > currentChance:
#						objectPlacement[x][y] = spawn_object(i,Vector2(x,y))
#						break
#					currentChance += ratesOfSpawning[i]
						
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
#			objectPlacement[blockToCheck.x].remove(blockToCheck.y)
#			objectPlacement[blockToCheck.x].insert(blockToCheck.y,null)
			
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
#			print(block)
	elif blockToCheck == Vector2(13,9):
#		print ("Checking Golem")
		golem_checking ()
	pass # Replace with function body.


func _on_Player_useItemOnBlock(itemID,itemTexture,blockToCheck,itemIndex):
	var block = objectPlacement[blockToCheck.x][blockToCheck.y]
	var itemDropSpot = itemDropPlacement[blockToCheck.x][blockToCheck.y]
	if !(block is Node2D) and !(itemDropSpot is Node2D):
		var newLoot = lootItemScene.instance()
		itemDropPlacement[blockToCheck.x].insert(blockToCheck.y,newLoot)
		newLoot.position = Vector2(blockToCheck.x,blockToCheck.y)*TILE_SIZE
		itemDrop.add_child(newLoot)
		newLoot.set_loot(itemID,itemTexture)
		GlobalPlayer.use_item(itemID,itemIndex)

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
	var keys = Recipes.golemRecipes.keys()
	for i in keys.size():
		var hasEverything = true
		var recipeItems =Recipes.golemRecipes[keys[i]].keys()
		for j in recipeItems.size():
			if !itemsFound.has(recipeItems[j]):
				hasEverything = false
			elif Recipes.golemRecipes[keys[i]][recipeItems[j]]>itemsFound[recipeItems[j]]:
				hasEverything = false
		if hasEverything:
			print ("ITS ALIVE! ",keys[i]," IS ALIVE")
			take_golem_items()
			$AnimationPlayer.play("GolemSpawning")
#	print (itemsFound)
	
func take_golem_items():
	var locations = [Vector2(14,7),Vector2(15,8),Vector2(15,10),Vector2(14,11),Vector2(12,11),Vector2(11,10),Vector2(11,8),Vector2(12,7)]
	for i in locations.size():
		var object = objectPlacement[locations[i].x][locations[i].y]
		if object is Node2D:
			object.queue_free()
			objectPlacement[locations[i].x].remove(locations[i].y)
			objectPlacement[locations[i].x].insert(locations[i].y,null)
	pass



func _on_EnemyManager_enemy_contact(enemyNode):
	GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.BATTLE)
	playerUI._enemy_battle_start(enemyNode)
	enemyNode.queue_free()
	pass # Replace with function body.

##################################################################################################
######################################DIALOG######################################################
##################################################################################################

func run_Dialog(partToPlay=null):
	if partToPlay != null:
		playerUI.run_Dialog(partToPlay)


##################################################################################################
######################################Transitions#################################################
##################################################################################################


func _on_SceneTransitions_transitionDone(transitionAnimation):
	if transitionAnimation == "radial_wipe_off":
		if whatToDoAfterTransition == "Cave Load":
			_on_new_level_cave_CaveSystem()
		elif whatToDoAfterTransition == "Leave Cave":
			_on_leave_cave_CaveSystem()
	pass # Replace with function body.
