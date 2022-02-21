extends Node2D

onready var lootSprite = $Sprite
var lootSprites = {
	0:"res://Assets/UI/Inventory/ItemUI/sprite_item_straw.png",
	1:"res://Assets/UI/Inventory/ItemUI/sprite_item_wood.png",
	2:"res://Assets/UI/Inventory/ItemUI/sprite_item_stone.png"
	}


var quantity = 0

# Called when the node enters the scene tree for the first time.
func set_loot(itemID,itemCount):
	lootSprite.texture = lootSprites[itemID].instance()
	quantity = itemCount
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
