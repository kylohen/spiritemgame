extends Node

enum ELEMENT{Nature, Lightning, Water, Fire, Ice, Wind, Void, Divine, Mundane, NONE}

var enemyStatBlocks = {
	0:{
		"Void StrawMan Argument":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Nature,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0003.png"
		}
	},
	1: {
		"Void Slippery Slope":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Ice,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0001.png"
			
		}
	},
	2: {
		"Void Gambler's Fallacy":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0004.png"
		}
	},
}

var playerGolemBaseStatBlocks = {
	0 : {
		"StrawBoy" : {
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0010.png"
			},
		},
	1 : {
		"Lead Zepplin":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0006.png"
			}
		},
	2: {
		"Twisted Whisker":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0008.png"
			}
		},
	}

