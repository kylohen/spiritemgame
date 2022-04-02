extends Control

onready var itemTexture = $Background/Item
onready var countText = $Count
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var quantity = 0
var type = null
var selectedItemTexture = ""
var itemIndex = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_item(itemID:String,itemCount:int,newIndex:int):
	if itemID !=null:
		selectedItemTexture = ItemTable.get_sprite(itemID)
		itemTexture.texture = load(selectedItemTexture)
		type = itemID
		quantity = itemCount
		itemIndex = newIndex
		if quantity is String:
			if quantity == "UNIQUE":
				countText.text = ""
		else: countText.text = str(quantity)
	pass
func reset():
	itemTexture.texture = null
	type = null
	itemIndex = null
	quantity = 0
	countText.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
