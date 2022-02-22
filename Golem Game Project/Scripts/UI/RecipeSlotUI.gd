extends Control

onready var recipeText = $SlotBackground/RecipeDetails
onready var itemPicture = $SlotBackground/ItemPicture


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var recipe

var hasNeededItems = false

func set_recipe(recipeDictEntry):
	var itemID = recipeDictEntry.keys()[0]
	var requiredItems = ""
	var keys = recipeDictEntry[itemID].keys()
	for i in keys.size():
		if i > 0:
			requiredItems += " + "
		requiredItems += str(recipeDictEntry[itemID][keys[i]])+"x "+itemID
	recipeText.text = itemID+":\n"+requiredItems
	
	recipe = recipeDictEntry
	

func _process(_delta):
	if hasNeededItems == true:
		self.modulate = Color(1,1,1,1)
	else: self.modulate = Color(.5,.5,.5,1)
