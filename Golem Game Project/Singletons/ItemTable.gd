extends Node

var UseItemList = {
	"Repair Dust" :{
		"USE":"Golem",
		"STAT":"CURRENT HP",
		"MODIFIERS": 25,
		"TARGET":StatBlocks.TARGET.BOTH,
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_repair_dust.png"
	},
}
var ResourceItemList = {
	"Dust" :{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_dust.png",
		},
	"Straw":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_straw.png",
		},
	"Wood":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_wood.png",
		},
	"Stone":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_stone.png",
		},
	"Metal Chunk":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_metal_chunk.png",
		},
	"Golem Core":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_golem_core.png",
		},
	"Crystal":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_crystal.png",
		},
	"Command Seal":{
		"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_command_seal.png",
		},
}

func get_sprite (itemName:String):
	if UseItemList.has(itemName):
		return UseItemList[itemName]["itemSprite"]
	elif ResourceItemList.has(itemName):
		return ResourceItemList[itemName]["itemSprite"]
	else:
		return "res://Assets/UI/Inventory/ItemUI/sprite_item_unknown.png"
		
		
