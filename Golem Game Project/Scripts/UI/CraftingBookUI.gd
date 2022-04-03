extends Control

##Notes: keeping it to demo vs building out the entire process


signal buttonSelectAudio
signal buttonMoveAudio

var page = 0

onready var recipesRow1 = $MarginContainer/BookBackground/Recipes/Row1
onready var recipesRow2 = $MarginContainer/BookBackground/Recipes/Row2
onready var playerRow1 = $MarginContainer/BookBackground/PlayerSelection/Row1
onready var playerRow2 = $MarginContainer/BookBackground/PlayerSelection/Row2
onready var leftButton = $MarginContainer/BookBackground/PageTurning/LeftButton
onready var rightButton = $MarginContainer/BookBackground/PageTurning/RightButton
var playerSelection = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	build_recipe_page()
	check_recipes_inventory()
	update_player_selection()
	pass # Replace with function body.

func build_recipe_page():
	var rangeOfRecipes = page*recipesRow1.get_child_count()
	var childPosition = 0
	for i in range(rangeOfRecipes, rangeOfRecipes + recipesRow1.get_child_count(),1):
		if Recipes.ItemRecipeDict.has(i):
			recipesRow1.get_child(childPosition).set_recipe(Recipes.ItemRecipeDict[i])
			recipesRow2.get_child(childPosition).set_recipe(Recipes.ItemRecipeDict[i])
		else:
			recipesRow1.get_child(childPosition).reset()
			recipesRow2.get_child(childPosition).reset()
		
		childPosition += 1
			
	
func update_player_selection():
	
	if playerSelection ==6:
		leftButton.modulate =  Color( 0, 0, 0, 1 ) 
#		rightButton.modulate =  Color( 1, 1, 1, 1 ) 
	elif playerSelection ==7:
		rightButton.modulate =  Color( 0, 0, 0, 1 ) 
#		leftButton.modulate =  Color( 1, 1, 1, 1 ) 
	elif playerSelection <= 5:
		playerRow1.get_child(playerSelection).modulate.a = 1.0
	
	pass
func remove_previous_selection_highlight (previousSelection):
	if previousSelection ==6:
#		leftButton.modulate =  Color( 0, 0, 0, 1 ) 
		leftButton.modulate =  Color( 1, 1, 1, 1 ) 
	elif previousSelection ==7:
#		rightButton.modulate =  Color( 0, 0, 0, 1 ) 
		rightButton.modulate =  Color( 1, 1, 1, 1 ) 
	elif previousSelection <= 5:
		playerRow1.get_child(previousSelection).modulate.a = 0.0
	

func move_up():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection ==0:
		playerSelection = 6
	elif playerSelection == 6 or playerSelection == 7:
		playerSelection = 5
	else: playerSelection -= 1
	
	emit_signal("buttonMoveAudio")
	update_player_selection()
func move_down():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection == 6 or playerSelection == 7:
		playerSelection=0
	else: playerSelection +=1
	
	emit_signal("buttonMoveAudio")
	update_player_selection()

func move_right():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection ==6:
		playerSelection = 7
	elif playerSelection ==7:
		playerSelection = 6
	emit_signal("buttonMoveAudio")
	update_player_selection()
func move_left():
	remove_previous_selection_highlight(playerSelection)
	if playerSelection ==6:
		playerSelection = 7
	elif playerSelection ==7:
		playerSelection = 6
	
	emit_signal("buttonMoveAudio")
	update_player_selection()
func selected():
	if playerSelection <= 5:
		if recipesRow1.get_child(playerSelection).hasNeededItems:
			GlobalPlayer.add_loot(Recipes.ItemRecipeDict[playerSelection].keys()[0],1)
			var itemToMake = Recipes.ItemRecipeDict[playerSelection].keys()[0]
			var keys = Recipes.ItemRecipeDict[playerSelection][itemToMake].keys()
			var hasAllItems = true
			for j in keys.size():
				if GlobalPlayer.has_item_and_quantity(keys[playerSelection],Recipes.ItemRecipeDict[playerSelection][itemToMake][keys[playerSelection]]):
					GlobalPlayer.use_item(keys[playerSelection],GlobalPlayer.inventoryListDict[keys[playerSelection]].keys()[0], Recipes.ItemRecipeDict[playerSelection][itemToMake][keys[playerSelection]])
					
			emit_signal("buttonSelectAudio")
	elif playerSelection == 6:
		page -= 1
		if page <0:
			page = 0
		build_recipe_page()
	elif playerSelection == 7:
		page += 1
		if page*recipesRow1.get_child_count() > Recipes.ItemRecipeDict.size():
			page -= 1
		build_recipe_page()
	
	
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
