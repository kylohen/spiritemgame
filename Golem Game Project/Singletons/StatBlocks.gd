extends Node

enum ELEMENT{Nature, Lightning, Water, Fire, Ice, Wind, Void, Divine, Mundane, NONE}
#enum STATE
enum TARGET{SELF,ENEMY,ALLY,AOE}

var aspectSprite = {
	ELEMENT.Nature : "res://Assets/UI/Bars/UI_Aspect_Nature.png",
	ELEMENT.Lightning : "res://Assets/UI/Bars/UI_Aspect_Lightning.png",
	ELEMENT.Water : "res://Assets/UI/Bars/UI_Aspect_Water.png",
	ELEMENT.Fire : "res://Assets/UI/Bars/UI_Aspect_Fire.png",
	ELEMENT.Ice : "res://Assets/UI/Bars/UI_Aspect_Ice.png",
	ELEMENT.Wind : "res://Assets/UI/Bars/UI_Aspect_Wind.png",
	ELEMENT.Void : "res://Assets/UI/Bars/UI_Aspect_Void.png",
	ELEMENT.Divine : "res://Assets/UI/Bars/UI_Aspect_Divine.png",
	ELEMENT.Mundane : "res://Assets/UI/Bars/UI_Aspect_Mundane.png",
}
var enemyStatBlocks = {
	0:{
		"Void StrawMan Argument":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Nature,
			"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0003.png",
			"NAME":"Void StrawMan Argument",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":20,
			"ASPECT":ELEMENT.Nature,
			"MODIFIERS":{},
			"LEVEL":1,
			"LOOT DROP":null,
			"ATTACK SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":3,
				"SKILL4":4,
				},
			"SUPPORT SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":3,
				"SKILL4":4,
				},
			"DEFEND SKILLS":{
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
			"NAME":"Void Slippery Slope",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Ice,
			"MODIFIERS":{},
			"LEVEL":1,
			"LOOT DROP":null,
			"ATTACK SKILLS":{
				"SKILL1":2,
				"SKILL2":1,
				"SKILL3":5,
				"SKILL4":3,
				},
			"SUPPORT SKILLS":{
				"SKILL1":2,
				"SKILL2":1,
				"SKILL3":5,
				"SKILL4":3,
				},
			"DEFEND SKILLS":{
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
			"NAME":"Void Gambler's Fallacy",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Fire,
			"MODIFIERS":{},
			"LEVEL":1,
			"LOOT DROP":null,
			"ATTACK SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":2,
				"SKILL4":5,
				},
			"SUPPORT SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":2,
				"SKILL4":5,
				},
			"DEFEND SKILLS":{
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
			"NAME":"StrawBoy",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Lightning,
			"MODIFIERS":{},
			"LEVEL":1,
			"ACTION METER":1,
			"MAGIC METER":1,
			"PLAYER AFFINITY":1,
			"ATTACK SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":4,
				"SKILL4":5,
				},
			"SUPPORT SKILLS":{
				"SKILL1":0,
				"SKILL2":2,
				"SKILL3":3,
				"SKILL4":4,
				},
			"DEFEND SKILLS":{
				"SKILL1":3,
				"SKILL2":0,
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
			"NAME":"Lead Zepplin",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Fire,
			"MODIFIERS":{},
			"LEVEL":1,
			"ACTION METER":1,
			"MAGIC METER":1,
			"PLAYER AFFINITY":1,
			"ATTACK SKILLS":{
				"SKILL1":0,
				"SKILL2":2,
				"SKILL3":3,
				"SKILL4":4,
				},
			"SUPPORT SKILLS":{
				"SKILL1":3,
				"SKILL2":0,
				"SKILL3":4,
				"SKILL4":5,
				},
			"DEFEND SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":4,
				"SKILL4":5,
				},
			}
		},
	2: {
		"Twisted Whisker":{
			"Type1": ELEMENT.Void,
			"Type2": ELEMENT.Fire,
			"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0008.png",
			"NAME":"Twisted Whisker",
			"HP":1,
			"ATTACK":1,
			"DEFENSE":1,
			"MAGIC ATTACK":1,
			"MAGIC DEFENSE":1,
			"SPEED":1,
			"ASPECT":ELEMENT.Fire,
			"MODIFIERS":{},
			"LEVEL":1,
			"ACTION METER":1,
			"MAGIC METER":1,
			"PLAYER AFFINITY":1,
			"ATTACK SKILLS":{
				"SKILL1":0,
				"SKILL2":1,
				"SKILL3":4,
				"SKILL4":5,
				},
			"SUPPORT SKILLS":{
				"SKILL1":3,
				"SKILL2":0,
				"SKILL3":4,
				"SKILL4":5,
				},
			"DEFEND SKILLS":{
				"SKILL1":0,
				"SKILL2":2,
				"SKILL3":3,
				"SKILL4":4,
				},
			}
		},
	}

var skillList = {
	0:{
		"Struggle":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"TYPE":"ATTACK",
			
			"MIN BONUS":.9,
			"MAX BONUS": 1.2,
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
			"DAMAGE":0,
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
			
			"MIN BONUS":.9,
			"MAX BONUS": 1.2,
			"TYPE":"ATTACK",
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":1,
			"MAGIC METER COST":0,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ENEMY,
			},
		},
	3:{
		"NAME":"Flame Breath",
		"DAMAGE":1,
		"ASPECT": ELEMENT.Mundane,
		"IMPACT TYPE": "MAGICAL",
		"TYPE":"ATTACK",
		
		"MIN BONUS":.9,
		"MAX BONUS": 1.2,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":0,
		"MAGIC METER COST":1,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.ENEMY,
		},
			
	4:{
		"Iron Shell":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"TYPE":"SUPPORT",
			
			"MIN BONUS":.9,
			"MAX BONUS": 1.2,
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
			"TYPE":"ATTACK",
			
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":0,
			"MAGIC METER COST":1,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ALLY,
			}		
		},
	6:{
		"RAH RAH":{
			"DAMAGE":1,
			"ASPECT": ELEMENT.Mundane,
			"IMPACT TYPE": "PHYSICAL",
			"TYPE":"SUPPORT",
			"STAT": "ATTACK",
			"STAT MOD": 1.5,
			"LOOTING MODIFIER":0,
			"CRIT PROBABILITY":1.2,
			"ACTION METER COST":0,
			"MAGIC METER COST":1,
			"PLAYER AFFINITY":0,
			"TARGET":TARGET.ALLY,
			}
	}
}
