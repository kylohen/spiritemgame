extends Control

onready var itemTexture = $Background/Item
onready var countText = $Count
var itemSprites = {
	"Straw":"res://Assets/UI/Inventory/ItemUI/sprite_item_straw.png",
	"Wood":"res://Assets/UI/Inventory/ItemUI/sprite_item_wood.png",
	"Rock":"res://Assets/UI/Inventory/ItemUI/sprite_item_stone.png",
	"Repair Dust":"res://Assets/UI/Inventory/ItemUI/sprite_item_repair_dust.png",
	"Dust":"res://Assets/UI/Inventory/ItemUI/sprite_item_dust.png"
}
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
		if !itemSprites.has(itemID):
			itemTexture.texture = load("res://Assets/UI/Inventory/ItemUI/sprite_item_unknown.png")
			selectedItemTexture = "res://Assets/UI/Inventory/ItemUI/sprite_item_unknown.png"
		else:
			itemTexture.texture = load(itemSprites[itemID])
			selectedItemTexture = itemSprites[itemID]
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
