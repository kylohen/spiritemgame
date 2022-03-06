extends Node

##Play state helps define what's going on in the game, 
##allowing for scenes to overlap eachother if needed
enum PLAYSTATE {GAME,MENU,PAUSE,BATTLE}

enum TOOLS {PICKAXE,AXE,SHOVEL,SCYTHE}
var toolSelected
var currentPLAYSTATE

var inventoryListDict={}
var itemIndexDict ={}
var nextInventoryIndex=0

var levelOfCave = 0
var deepestLevelOfCave = 0
var playerName = "Player"
var partyGolems = []
var PLAYERSTATS = {
	"ATTACK":1,
	"HP":20,
	"FLEE STAT":1,
	"SPEED":4,
	"SKILLS":{
		"SKILL1":0,
		"SKILL2":1,
		"SKILL3":1,
		"SKILL4":1,
	}
}
func _ready():
	currentPLAYSTATE = PLAYSTATE.GAME
	pass # Replace with function body.

## updates the selected tool to the new tool provided
func update_tool (newTool) -> void:
	toolSelected = newTool

##Checks if game is in the play state and returns a bool
func is_PLAYSTATE(state)->bool:
	if currentPLAYSTATE == state:
		return true
	return false

##Sorter key for index of where items are stored in inventory slots
class _add_loot_sorter:
	static func sort_ascending(valueA,valueB):
		if valueA[0]<valueB[0]:
			return true
		return false
	
func add_loot(lootType,quantity):
	if inventoryListDict.has(lootType):
		var keys = inventoryListDict[lootType].keys()
		keys.sort_custom(_add_loot_sorter, "sort_ascending")
		for i in keys.size():
			var currentInventoryCount = inventoryListDict[lootType][keys[i]] 
			if currentInventoryCount <= 99:
				if currentInventoryCount + quantity <= 99:
					inventoryListDict[lootType][keys[i]] += quantity
					quantity = 0
				else:
					inventoryListDict[lootType][keys[i]] = 99
					quantity = currentInventoryCount+quantity-99
					
	####if it doesn't have the key or the quantity is still more than the max existing and needs a new key
	if quantity > 0:
		for i in range (0,quantity,99):
			if i+99 > quantity:
				var indexItem = new_index()
				inventoryListDict[lootType] = {indexItem:0}
				inventoryListDict[lootType][indexItem] += quantity
				itemIndexDict[indexItem] = lootType
			else:
				var indexItem = new_index()
				inventoryListDict[lootType] = {indexItem:0}
				inventoryListDict[lootType][indexItem] += i+99
				itemIndexDict[indexItem] = lootType
func new_index():
	var unusedNumber = 0
	while itemIndexDict.has(unusedNumber):
		 unusedNumber += 1 
	nextInventoryIndex = unusedNumber
	return nextInventoryIndex

func swap_item_locations (itemA,itemAIndex,itemB,itemBIndex):
	
	
	if itemA == itemB and (itemA != null and itemB != null):
		var quantityA = inventoryListDict[itemA][itemAIndex]
		var quantityB = inventoryListDict[itemB][itemBIndex]
		if quantityA + quantityB <=99:
			inventoryListDict[itemA][itemAIndex] = quantityA + quantityB 
			delete_item(itemB,itemBIndex)
		else:
			inventoryListDict[itemA][itemAIndex] = 99
			inventoryListDict[itemB][itemBIndex] = 99 - (quantityA + quantityB)
	else:
		var dictA 
		var dictB 
		if itemA == null:
			dictA = null
			itemIndexDict.erase(itemBIndex)
		else: 
			dictA = inventoryListDict[itemA][itemAIndex]
			
		if itemB == null:
			dictB = null
			itemIndexDict.erase(itemAIndex)
		else:
			dictB = inventoryListDict[itemB][itemBIndex]
		if itemA == null and itemB != null:
			itemIndexDict[itemAIndex] = itemB
		elif itemA != null and itemB == null:
			itemIndexDict[itemBIndex] = itemA
		elif itemA != null and itemB != null:
			itemIndexDict[itemAIndex] = itemB
			itemIndexDict[itemBIndex] = itemA
		## if all is null, no changes needed
		
		
		if inventoryListDict.has(itemA):
			inventoryListDict[itemA].erase(itemAIndex)
			
		if inventoryListDict.has(itemB):
			inventoryListDict[itemB].erase(itemBIndex)
		
		if dictA == null and dictB == null:
			pass
		else:
			if dictA != null:
				inventoryListDict[itemA][itemBIndex] = dictA
			else:inventoryListDict[itemB].erase(itemBIndex)
			if dictB != null:
				inventoryListDict[itemB][itemAIndex] = dictB 
			else:inventoryListDict[itemA].erase(itemAIndex)
			print ("itemIndexDict: ",itemIndexDict)
			print ("inventoryListDict: ",inventoryListDict)
	
func delete_item (itemToDelete,IndexToClear):
	inventoryListDict[itemToDelete].erase(IndexToClear)
	itemIndexDict.erase(IndexToClear)
	pass

func use_item(itemToUse,indexToUse, quantityToUse = 1):
	inventoryListDict[itemToUse][indexToUse] -= quantityToUse
	if inventoryListDict[itemToUse][indexToUse]<= 0:
		delete_item(itemToUse,indexToUse)

func has_item(itemToCheck):
	return inventoryListDict.has(itemToCheck)

func has_item_and_quantity(itemToCheck, quantity):
	if inventoryListDict.has(itemToCheck):
		var keys = inventoryListDict[itemToCheck].keys()
		for i in keys.size():
			quantity -= inventoryListDict[itemToCheck][keys[i]]
			if quantity <=0:
				return true
	return false

func Go_Down_A_Level(downAmount = 1):
	levelOfCave += downAmount
	if deepestLevelOfCave < levelOfCave:
		deepestLevelOfCave = levelOfCave
	
func add_golem(golemID):
	if partyGolems.size() >= 7:
		return false
	else:
		var newGolemInput = StatBlocks.playerGolemBaseStatBlocks[golemID].duplicate()
		newGolemInput["CURRENT ACTION"] = newGolemInput["ACTION METER"]
		newGolemInput["CURRENT MAGIC"] = newGolemInput["MAGIC ACTION METER"]
		newGolemInput["CURRENT HP"] = newGolemInput["HP"]
		partyGolems.append(newGolemInput)

