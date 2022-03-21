extends Node2D

onready var lootSprite = $Sprite
#var lootSprites = {
#	"Wood":"res://Assets/UI/Inventory/ItemUI/sprite_item_straw.png",
#	1:"res://Assets/UI/Inventory/ItemUI/sprite_item_wood.png",
#	2:"res://Assets/UI/Inventory/ItemUI/sprite_item_stone.png"
#	}

var type = "loot"
var itemID
var quantity = 1

# Called when the node enters the scene tree for the first time.
func set_loot(newItemID,newLootTexture, newQuantity = quantity):
	lootSprite.texture = load(newLootTexture)
	itemID = newItemID
	quantity = newQuantity
	pass
	
func is_passable():return true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func toolUsed():return false
