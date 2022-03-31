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
	
	build_golem_generator()
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


func build_golem_generator():
	var locations = [Vector2(14,7),Vector2(15,8),Vector2(15,10),Vector2(14,11),Vector2(12,11),Vector2(11,10),Vector2(11,8),Vector2(12,7)]
	for i in locations.size():
		var pedestal = overworldObjectScene.instance()
		interactOverlay.add_child(pedestal)
		pedestal.position = locations[i]*TILE_SIZE
		pedestal.spawn_object(WorldConductor.objectTypes.Pedestal)
		objectPlacement[locations[i].x][locations[i].y]= pedestal
	var golemGenerator = overworldObjectScene.instance()
	interactOverlay.add_child(golemGenerator)
	golemGenerator.position = Vector2(13,9)*TILE_SIZE
	golemGenerator.spawn_object(WorldConductor.objectTypes.GolemGenerator)
	objectPlacement[13][9]= golemGenerator
	pass
func chanceOfSpawningResource(x,y,selectedTile):
	var chanceOfSpawn = 0.20 # 20% spawn chance
	var objectPossibleSpawns = objectTypePerTileTypeDict[selectedTile]
	var block = gridMap[x][y]
	var object = objectPlacement[x][y]
	if !objectPossibleSpawns.empty():
		if (block == null or !(block is int)) and object == null:
			for i in objectPossibleSpawns.size():
				var rollForItem = SeedGenerator.rng.randf_range(0,1)
				if rollForItem <chanceOfSpawn:
					objectPlacement[x][y] = spawn_object(objectPossibleSpawns[i],Vector2(x,y))
					break
func spawnCave(numberOfCaves = 5):
	var count = 0
	while numberOfCaves>0:
		var randomLocation = Vector2(SeedGenerator.rng.randi_range(0,gridWidth-1),SeedGenerator.rng.randi_range(0,gridHeight-1))
		var block = gridMap[randomLocation.x][randomLocation.y]
		var object = objectPlacement[randomLocation.x][randomLocation.y]
		if object == null:
			overworld.set_cell(randomLocation.x,randomLocation.y,11)
			caveLocations.append(randomLocation)
			gridMap[randomLocation.x][randomLocation.y] = 11
			numberOfCaves -= 1
		count +=1
		if count >= 100*numberOfCaves:
			print("couldn't find ",numberOfCaves," Caves")
			break
## checks to see if there is something in the grid, if there is, return false
func is_Open_Tile(currentPosition, directionToGo,isPlayer=true) -> bool:
	var newPosition = currentPosition + directionToGo
	var block = objectPlacement[newPosition.x][newPosition.y]
	var itemCheck = itemDropPlacement[newPosition.x][newPosition.y]
	if isPlayer:
		pickUpItem(itemCheck,newPosition)
		if caveLocations.has(newPosition):
			sceneTransitions.run_Transition("radial_wipe_off")
			whatToDoAfterTransition = "Cave Load"
	if block != null:
		if !(block is int):##Walls and other impassable and immutable terrain is stored as ints
			
			
			if block.type != null:
				return objectPlacement[newPosition.x][newPosition.y].is_passable()
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

			elif block.objectSelected== WorldConductor.objectTypes.GolemGenerator:
		#		print ("Checking Golem")
				golem_checking ()
			pass # Replace with function body.


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

func golem_checking ():
	var arrayOfPodiums = podium_checking()
	var itemsFound = {}
	if !arrayOfPodiums.empty():
		for i in arrayOfPodiums.size():
			var object = arrayOfPodiums[i][0]
			var location = arrayOfPodiums[i][1]
			if object is Node2D:
				if object.type == "loot":
					if itemsFound.has(object.itemID):
						itemsFound[object.itemID]["QTY"] += 1
						itemsFound[object.itemID]["LOCATION ARRAY"].append(location)
					else:
						itemsFound[object.itemID] = {"QTY": 1,"LOCATION ARRAY":[location]}
		var keys = Recipes.golemRecipes.keys()
		var useItems = []
		for i in keys.size():
			var hasEverything = true
			var recipeItems = Recipes.golemRecipes[keys[i]].keys()
			for j in recipeItems.size():
				if !itemsFound.has(recipeItems[j]):
					hasEverything = false
					break
				elif Recipes.golemRecipes[keys[i]][recipeItems[j]]>itemsFound[recipeItems[j]]["QTY"]:
					hasEverything = false
					break
			if hasEverything:
				for j in recipeItems.size():
					for count in Recipes.golemRecipes[keys[i]][recipeItems[j]]:
						useItems.append(itemsFound[recipeItems[j]]["LOCATION ARRAY"][count])
				print ("ITS ALIVE! ",keys[i]," IS ALIVE")
				take_golem_items(useItems)
				$AnimationPlayer.play("GolemSpawning")
				break
func podium_checking():
	var arrayOfPodiumPlacements = []
#	[[LootItem,Vector2(locationOfItem)],...]
	for i in objectPlacement.size():
		for j in objectPlacement[i].size():
			if objectPlacement[i][j] is Node2D:
				if objectPlacement[i][j].objectSelected == WorldConductor.objectTypes.Pedestal:
					if itemDropPlacement[i][j] is Node2D:
						arrayOfPodiumPlacements.append([itemDropPlacement[i][j],Vector2(i,j)])
	return arrayOfPodiumPlacements

func take_golem_items(useItems):
	for i in useItems.size():
		var objectLocation = useItems[i]
		itemDropPlacement[objectLocation.x][objectLocation.y].queue_free()
		itemDropPlacement[objectLocation.x].remove(objectLocation.y)
		itemDropPlacement[objectLocation.x].insert(objectLocation.y,null)
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
