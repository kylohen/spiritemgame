extends Control

##Notes: keeping it to demo vs building out the entire process


signal buttonSelectAudio
signal buttonMoveAudio


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
		if Recipes.ItemRecipeDict.has(i):
			recipesRow1.get_child(i).set_recipe(Recipes.ItemRecipeDict[i])
			recipesRow2.get_child(i).set_recipe(Recipes.ItemRecipeDict[i])
			
	
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
	
	emit_signal("buttonMoveAudio")
	update_player_selection()
func move_down():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection == 2:
		playerSelection=0
	else: playerSelection +=1
	
	emit_signal("buttonMoveAudio")
	update_player_selection()
func selected():
	if recipesRow1.get_child(playerSelection).hasNeededItems:
		GlobalPlayer.add_loot(Recipes.ItemRecipeDict[playerSelection].keys()[0],1)
		var itemToMake = Recipes.ItemRecipeDict[playerSelection].keys()[0]
		var keys = Recipes.ItemRecipeDict[playerSelection][itemToMake].keys()
		var hasAllItems = true
		for j in keys.size():
			if GlobalPlayer.has_item_and_quantity(keys[playerSelection],Recipes.ItemRecipeDict[playerSelection][itemToMake][keys[playerSelection]]):
				GlobalPlayer.use_item(keys[playerSelection],GlobalPlayer.inventoryListDict[keys[playerSelection]].keys()[0], Recipes.ItemRecipeDict[playerSelection][itemToMake][keys[playerSelection]])
				
				emit_signal("buttonSelectAudio")
	
	
	
func check_recipes_inventory():
	for i in recipesRow1.get_child_count():
		if Recipes.ItemRecipeDict.has(i):
			var itemToMake = Recipes.ItemRecipeDict[i].keys()[0]
			var keys = Recipes.ItemRecipeDict[i][itemToMake].keys()
			var hasAllItems = true
			for j in keys.size():
				if !GlobalPlayer.has_item_and_quantity(keys[j],Recipes.ItemRecipeDict[i][itemToMake][keys[j]]):
					hasAllItems = false
			recipesRow1.get_child(i).hasNeededItems = hasAllItems
			recipesRow2.get_child(i).hasNeededItems = hasAllItems
func not_primary():
	pass


func _on_InventoryChecker_timeout():
	check_recipes_inventory()
	pass # Replace with function body.
