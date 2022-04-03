extends Control

onready var recipeText = $SlotBackground/RecipeDetails
onready var recipeName = $SlotBackground/RecipeName
onready var itemPicture = $SlotBackground/ItemPicture

export (bool) var isRecipeDescription = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var recipe

var hasNeededItems = false

func set_recipe(recipeDictEntry):
	var itemID = recipeDictEntry.keys()[0]
	var requiredItems = ""
	var keys = recipeDictEntry[itemID].keys()
	recipeText.text = ""
	recipeName.text = ""
	if isRecipeDescription:
		for i in keys.size():
			requiredItems += " "+str(recipeDictEntry[itemID][keys[i]])+"x "+itemID +"\n"
			recipeText.text = requiredItems
		pass
	else:
		itemPicture.texture = load(ItemTable.get_sprite(itemID))
		recipeName.text = itemID
	
	recipe = recipeDictEntry

func reset ():
	hasNeededItems = false
	recipeText.text = ""
	recipeName.text = ""
	itemPicture.texture = null
	
func _process(_delta):
	if hasNeededItems == true:
		self.modulate = Color(1,1,1,1)
	else: self.modulate = Color(.5,.5,.5,1)
