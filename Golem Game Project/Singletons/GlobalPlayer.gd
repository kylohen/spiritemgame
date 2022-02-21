extends Node

##Play state helps define what's going on in the game, 
##allowing for scenes to overlap eachother if needed
enum PLAYSTATE {GAME,MENU,PAUSE}

enum TOOLS {PICKAXE,AXE,SHOVEL,SCYTHE}
var toolSelected
var currentPLAYSTATE

var inventoryListDict={}
var itemIndexDict ={}
var nextInventoryIndex=0


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
	nextInventoryIndex += 1 
	return nextInventoryIndex - 1

func swap_item_locations (itemA,itemAIndex,itemB,itemBIndex):
	itemIndexDict[itemAIndex] = itemB
	itemIndexDict[itemBIndex] = itemA
	
	var dictA = inventoryListDict[itemA][itemAIndex].duplicate()
	var dictB = inventoryListDict[itemB][itemBIndex].duplicate()
	inventoryListDict[itemA].erase(itemAIndex)
	inventoryListDict[itemB].erase(itemBIndex)
	inventoryListDict[itemA][itemBIndex] = dictB
	inventoryListDict[itemB][itemAIndex] = dictA
	
