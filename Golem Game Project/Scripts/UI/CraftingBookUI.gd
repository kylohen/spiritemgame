extends Control

##Notes: keeping it to demo vs building out the entire process
var RecipeDict = {
	0:{
		"Straw Bundle":{
			"Straw":9,
			},
		},
	1:{
		"Golem Core" : {
			"Aspect Crystal": 1,
			"Runic Matrix" : 1,
			},
		},
	2:{
		"Command Seal" :{
			"Wax" : 2,
			"Glimmerdust" : 1,
			},
		},
	}

onready var recipesRow1 = $MarginContainer/BookBackground/Recipes/Row1
onready var recipesRow2 = $MarginContainer/BookBackground/Recipes/Row2
onready var playerRow1 = $MarginContainer/BookBackground/PlayerSelection/Row1
onready var playerRow2 = $MarginContainer/BookBackground/PlayerSelection/Row2

var playerSelection = 0

var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	build_recipe_page()
	check_recipes_inventory()
	update_player_selection()
	pass # Replace with function body.

func build_recipe_page():
	for i in recipesRow1.get_child_count():
		if RecipeDict.has(i):
			recipesRow1.get_child(i).set_recipe(RecipeDict[i])
			
	
func update_player_selection():
	playerRow1.get_child(playerSelection).modulate.a = 1.0
	
	pass
func remove_previous_selection_highlight (previousSelection):
	playerRow1.get_child(previousSelection).modulate.a = 0.0
	

func move_up():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection ==0:
		playerSelection = 2
	else: playerSelection -= 1
	update_player_selection()
func move_down():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection == 2:
		playerSelection=0
	else: playerSelection +=1
	update_player_selection()
func selected():
	if recipesRow1.get_child(playerSelection).hasNeededItems:
		GlobalPlayer.add_loot(RecipeDict[playerSelection].keys()[0],1)
		var itemToMake = RecipeDict[playerSelection].keys()[0]
		var keys = RecipeDict[playerSelection][itemToMake].keys()
		var hasAllItems = true
		for j in keys.size():
			if GlobalPlayer.has_item_and_quantity(keys[playerSelection],RecipeDict[playerSelection][itemToMake][keys[playerSelection]]):
				GlobalPlayer.use_item(keys[playerSelection],GlobalPlayer.inventoryListDict[keys[playerSelection]].keys()[0], RecipeDict[playerSelection][itemToMake][keys[playerSelection]])
	
	
	
func check_recipes_inventory():
	for i in recipesRow1.get_child_count():
		if RecipeDict.has(i):
			var itemToMake = RecipeDict[i].keys()[0]
			var keys = RecipeDict[i][itemToMake].keys()
			var hasAllItems = true
			for j in keys.size():
				if !GlobalPlayer.has_item_and_quantity(keys[j],RecipeDict[i][itemToMake][keys[j]]):
					hasAllItems = false
			recipesRow1.get_child(i).hasNeededItems = hasAllItems
func not_primary():
	pass


func _on_InventoryChecker_timeout():
	check_recipes_inventory()
	pass # Replace with function body.
