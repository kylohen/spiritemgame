extends Node

enum ELEMENT{Nature, Lightning, Water, Fire, Ice, Wind, Void, Divine, Mundane, NONE}
#enum STATE
enum TARGET{SELF,ENEMY,ALLY,AOE}

var enemyStatBlocks = {
	0:{
		"Void StrawMan Argument":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Nature,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0003.png",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Nature,
			"LEVEL":1,
			"LOOT DROP":null,
			"SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":3,
				"SKILL4":4,
				},
		}
	},
	1: {
		"Void Slippery Slope":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Ice,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0001.png",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Ice,
			"LEVEL":1,
			"LOOT DROP":null,
			"SKILLS":{
				"SKILL1":2,
				"SKILL2":1,
				"SKILL3":5,
				"SKILL4":3,
				},
		}
	},
	2: {
		"Void Gambler's Fallacy":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0004.png",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Fire,
			"LEVEL":1,
			"LOOT DROP":null,
			"SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":2,
				"SKILL4":5,
				},
		}
	},
}

var playerGolemBaseStatBlocks = {
	0 : {
		"StrawBoy" : {
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0010.png",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Lightning,
			"LEVEL":1,
			"ACTION METER":1,
			"MAGIC ACTION METER":1,
			"PLAYER AFFINITY":1,
			"SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":4,
				"SKILL4":5,
				},
			},
		},
	1 : {
		"Lead Zepplin":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0006.png",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Fire,
			"LEVEL":1,
			"ACTION METER":1,
			"MAGIC ACTION METER":1,
			"PLAYER AFFINITY":1,
			"SKILLS":{
				"SKILL1":0,
				"SKILL2":2,
				"SKILL3":3,
				"SKILL4":4,
				},
			}
		},
	2: {
		"Twisted Whisker":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0008.png",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Fire,
			"LEVEL":1,
			"ACTION METER":1,
			"MAGIC ACTION METER":1,
			"PLAYER AFFINITY":1,
			"SKILLS":{
				"SKILL1":3,
				"SKILL2":0,
				"SKILL3":4,
				"SKILL4":5,
				},
			}
		},
	}

var skillList = {
	0:{
		"Struggle":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":1,
			"MAGIC METER COST":0,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ENEMY,
			},
		},
	1:{
		"Flee":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":0,
			"MAGIC METER COST":1,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.SELF,
			}
			
		},
	2:{
		"Basic Attack":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":1,
			"MAGIC METER COST":0,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ENEMY,
			},
		},
	3:{
		"Flame Breath":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":0,
			"MAGIC METER COST":1,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ENEMY,
			}
			
		},
	4:{
		"Iron Shell":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":1,
			"MAGIC METER COST":0,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ENEMY,
			},
		},
	5:{
		"Self Emolate":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":0,
			"MAGIC METER COST":1,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ENEMY,
			}
			
		},
	}
