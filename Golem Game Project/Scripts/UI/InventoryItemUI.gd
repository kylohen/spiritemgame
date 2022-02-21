extends Control

onready var itemTexture = $Background/Item
onready var countText = $Count
var itemSprites = {
	"Straw":"res://Assets/UI/Inventory/ItemUI/sprite_item_straw.png",
	"Wood":"res://Assets/UI/Inventory/ItemUI/sprite_item_wood.png",
	"Rock":"res://Assets/UI/Inventory/ItemUI/sprite_item_stone.png"
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var quantity = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_item(itemID,itemCount):
	itemTexture.texture = load(itemSprites[itemID])
	quantity = itemCount
	countText.text = str(quantity)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
