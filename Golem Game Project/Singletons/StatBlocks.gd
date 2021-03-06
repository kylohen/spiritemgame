extends Node

enum ELEMENT{Nature, Lightning, Water, Fire, Ice, Wind, Void, Divine, Mundane, NONE}
#enum STATE
enum TARGET{SELF,ENEMY,ALLY,AOE_ALLY,AOE_ENEMY,BOTH}

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

##########GOLEM DICTIONARY STRUCTURE###########
#{
	#"NAME": ##STRING Name of GOLEM
	#"Type1": ELEMENT.Void,    ##UNUSED AT THIS TIME
	#"Type2": ELEMENT.Nature,  ##UNUSED AT THIS TIME
	#"frontSprite": ##String location of Art Asset
	#"backSprite":##String location of Art Asset - only for playerGolems
	#"PARTY ICON":##String location of Art Asset - only for playerGolems
	#"HP": ##Int for max HP
	#"ATTACK":##Int for Attack
	#"DEFENSE":##Int for DEFENSE
	#"MAGIC ATTACK": ##Int for MAGIC ATTACK
	#"MAGIC DEFENSE":##Int for MAGIC DEFENSE
	#"SPEED":##Int for SPEED
	#"ASPECT":# enum of type, e.g ELEMENT.Lightning
	#"MODIFIERS":{}, #empty dict to be used by battle logic
	#"DAMAGE OVER TIME":{},#empty dict to be used by battle logic
	#"ACTION METER": ##Int for max ACTION
	#"MAGIC METER": ##Int for max MAGIC
	#"CURRENT ACTION": ##Int for CURRENT ACTION
	#"CURRENT MAGIC": ##Int forCURRENT MAGIC
	#"AFFINITY":##Int for AFFINITY
	#"LEVEL":##Int for LEVEL
	#"NORMAL LOOT DROP": ### Dictionary of ItemID: Quantity e.g {"Dust":3}
	#"RARE LOOT DROP":### Dictionary of ItemID: Quantity e.g {"Dust":3}
	#"ATTACK SKILLS": ### Dictionary of Skill Slot and SkillID {"SKILL1":3,"SKILL2":2,"SKILL3":null,"SKILL4":null,},
	#"SUPPORT SKILLS":### Dictionary of Skill Slot and SkillID {"SKILL1":3,"SKILL2":2,"SKILL3":null,"SKILL4":null,},
	#"DEFEND SKILLS":### Dictionary of Skill Slot and SkillID {"SKILL1":3,"SKILL2":2,"SKILL3":null,"SKILL4":null,},
#}
var enemyStatBlocks = {
	0:{
		"NAME":"Void StrawMan Argument",
		"Type1": ELEMENT.Void,
		"Type2": ELEMENT.Nature,
		"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0003.png",
		"HP":1,
		"ATTACK":1,
		"DEFENSE":1,
		"MAGIC ATTACK":1,
		"MAGIC DEFENSE":1,
		"SPEED":20,
		"ASPECT":ELEMENT.Nature,
		"MODIFIERS":{},
		"DAMAGE OVER TIME":{},
		"ACTION METER":1000,
		"MAGIC METER":1000,
		"CURRENT ACTION":1000,
		"CURRENT MAGIC":1000,
		"AFFINITY":1,
		"LEVEL":1,
		"NORMAL LOOT DROP":{
			"Dust":3,
		},
		"RARE LOOT DROP":{
			"Command Seal":1,
		},
		"ATTACK SKILLS":{
			"SKILL1":3,
			"SKILL2":2,
			"SKILL3":null,
			"SKILL4":null,
			},
		"SUPPORT SKILLS":{
			"SKILL1":6,
			"SKILL2":null,
			"SKILL3":null,
			"SKILL4":4,
			},
		"DEFEND SKILLS":{
			"SKILL1":null,
			"SKILL2":7,
			"SKILL3":null,
			"SKILL4":null,
			},
		},
	1: {
		"NAME":"Void Slippery Slope",
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
		"MODIFIERS":{},
		"DAMAGE OVER TIME":{},
		"ACTION METER":1000,
		"MAGIC METER":1000,
		"CURRENT ACTION":1000,
		"CURRENT MAGIC":1000,
		"AFFINITY":1,
		"LEVEL":1,
		"NORMAL LOOT DROP":{
			"Dust":3,
		},
		"RARE LOOT DROP":{
			"Command Seal":1,
		},
		"ATTACK SKILLS":{
			"SKILL1":3,
			"SKILL2":2,
			"SKILL3":null,
			"SKILL4":null,
			},
		"SUPPORT SKILLS":{
			"SKILL1":4,
			"SKILL2":6,
			"SKILL3":null,
			"SKILL4":null,
			},
		"DEFEND SKILLS":{
			"SKILL1":null,
			"SKILL2":7,
			"SKILL3":null,
			"SKILL4":null,
			},
		},
	2: {
		"NAME":"Void Gambler's Fallacy",
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
		"MODIFIERS":{},
		"DAMAGE OVER TIME":{},
		"AFFINITY":1,
		"LEVEL":1,
		"NORMAL LOOT DROP":{
			"Dust":3,
		},
		"RARE LOOT DROP":{
			"Command Seal":1,
		},
		"ACTION METER":1000,
		"MAGIC METER":1000,
		"CURRENT ACTION":1000,
		"CURRENT MAGIC":1000,
		"ATTACK SKILLS":{
			"SKILL1":3,
			"SKILL2":2,
			"SKILL3":null,
			"SKILL4":null,
			},
		"SUPPORT SKILLS":{
			"SKILL1":4,
			"SKILL2":6,
			"SKILL3":null,
			"SKILL4":null,
			},
		"DEFEND SKILLS":{
			"SKILL1":null,
			"SKILL2":7,
			"SKILL3":null,
			"SKILL4":null,
			},
		},
	}

var playerGolemBaseStatBlocks = {
	0 : {
		"NAME":"Strawlem",
		"Type1": ELEMENT.Void,
		"Type2": ELEMENT.Fire,
		"frontSprite":"res://Assets/sprites/playerGolemFrontSprites/Strawlem/Mundane/strawlem_mundane.png",
		"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0010.png",
		"PARTY ICON":"res://Assets/sprites/playerGolemFrontSprites/Strawlem/Mundane/strawlem_mundane.png",
		"HP":10,
		"ATTACK":1,
		"DEFENSE":1,
		"MAGIC ATTACK":1,
		"MAGIC DEFENSE":1,
		"SPEED":1,
		"ASPECT":ELEMENT.Lightning,
		"MODIFIERS":{},
		"DAMAGE OVER TIME":{},
		"LEVEL":1,
		"ACTION METER":1,
		"MAGIC METER":1,
		"AFFINITY":1,
		"ATTACK SKILLS":{
			"SKILL1":0,
			"SKILL2":2,
			"SKILL3":3,
			"SKILL4":null,
			},
		"SUPPORT SKILLS":{
			"SKILL1":6,
			"SKILL2":4,
			"SKILL3":null,
			"SKILL4":null,
			},
		"DEFEND SKILLS":{
			"SKILL1":7,
			"SKILL2":null,
			"SKILL3":null,
			"SKILL4":null,
			},
		"UPGRADE COST": 5,
		},
	1 : {
		"NAME":"Lead Zepplin",
		"Type1": ELEMENT.Void,
		"Type2": ELEMENT.Fire,
		"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0010.png",
		"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0006.png",
		"PARTY ICON":"",
		"HP":10,
		"ATTACK":1,
		"DEFENSE":1,
		"MAGIC ATTACK":1,
		"MAGIC DEFENSE":1,
		"SPEED":1,
		"ASPECT":ELEMENT.Fire,
		"MODIFIERS":{},
		"DAMAGE OVER TIME":{},
		"LEVEL":1,
		"ACTION METER":1,
		"MAGIC METER":1,
		"AFFINITY":1,
		"ATTACK SKILLS":{
			"SKILL1":null,
			"SKILL2":2,
			"SKILL3":3,
			"SKILL4":0,
			},
		"SUPPORT SKILLS":{
			"SKILL1":6,
			"SKILL2":null,
			"SKILL3":null,
			"SKILL4":4,
			},
		"DEFEND SKILLS":{
			"SKILL1":null,
			"SKILL2":7,
			"SKILL3":null,
			"SKILL4":null,
			},
		"UPGRADE COST": 5,
		},
	2: {
		"NAME":"Twisted Whisk",
		"Type1": ELEMENT.Void,
		"Type2": ELEMENT.Fire,
		"frontSprite":"res://Assets/sprites/VoidSprites/Sprite-0010.png",
		"backSprite":"res://Assets/sprites/VoidSprites/Sprite-0008.png",
		"PARTY ICON":"",
		"HP":10,
		"ATTACK":1,
		"DEFENSE":1,
		"MAGIC ATTACK":1,
		"MAGIC DEFENSE":1,
		"SPEED":1,
		"ASPECT":ELEMENT.Fire,
		"MODIFIERS":{},
		"DAMAGE OVER TIME":{},
		"LEVEL":1,
		"ACTION METER":1,
		"MAGIC METER":1,
		"AFFINITY":1,
		"ATTACK SKILLS":{
			"SKILL1":0,
			"SKILL2":null,
			"SKILL3":3,
			"SKILL4":2,
			},
		"SUPPORT SKILLS":{
			"SKILL1":null,
			"SKILL2":null,
			"SKILL3":6,
			"SKILL4":4,
			},
		"DEFEND SKILLS":{
			"SKILL1":null,
			"SKILL2":null,
			"SKILL3":null,
			"SKILL4":7,
			},
		"UPGRADE COST": 5,
		},
	}

#var skillList = {
#	0 #Unique Number:{
#		"NAME":"Struggle", #String
#		"BASE DAMAGE":1, #Int
#		"ASPECT": ELEMENT.Mundane, #Element of Skill
#		"TYPE":"ATTACK", #Category of Type of Skill
#
#		"MIN BONUS":.9, #rnd rang min
#		"MAX BONUS": 1.2, #rnd rang min
#		"IMPACT TYPE": "PHYSICAL", # String of PHYSICAL/MAGICAL to utilize the Attack/Defense and Magic Attack/Magic Defense
#		"LOOTING MODIFIER":0, #adjust looting modifier 
#		"CRIT PROBABILITY":1.2,
#		"ACTION METER COST":1, #cost of skill to use on ACTION
#		"MAGIC METER COST":0, #cost of skill to use on MAGIC
#		"PLAYER AFFINITY":0, #Affintiy not implimented, but would affect the effectiveness of skill
#		"TARGET":TARGET.ENEMY, #enum of waht the skill can target {SELF,ENEMY,ALLY,AOE_ALLY,AOE_ENEMY,BOTH}
#		},
var skillList = {
	0:{
		"NAME":"Struggle",
		"BASE DAMAGE":1,
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
	1:{
		"NAME":"Flee",
		"BASE DAMAGE":0,
		"ASPECT": ELEMENT.Mundane,
		"IMPACT TYPE": "PHYSICAL",
		"TYPE":"SUPPORT",
		"DURATION":3,
		"STAT": "SPEED",
		"STAT MOD": 1.0,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":0,
		"MAGIC METER COST":1,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.SELF,
			
		},
	2:{
		"NAME":"Basic Attack",
		"BASE DAMAGE":1,
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
	3:{
		"NAME":"Flame Breath",
		"BASE DAMAGE":1,
		"ASPECT": ELEMENT.Fire,
		"IMPACT TYPE": "MAGICAL",
		"TYPE":"ATTACK",
		
		"MIN BONUS":.9,
		"MAX BONUS": 1.2,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":0,
		"MAGIC METER COST":1,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.AOE_ENEMY,
		},
			
	4:{
		"NAME":"Iron Shell",
		"BASE DAMAGE":1,
		"ASPECT": ELEMENT.Mundane,
		"IMPACT TYPE": "PHYSICAL",
		"TYPE":"SUPPORT",
		"STAT": "DEFENSE",
		"DURATION":3,
		"STAT MOD": 1.5,
		
		"MIN BONUS":.9,
		"MAX BONUS": 1.2,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":1,
		"MAGIC METER COST":0,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.ALLY,
		},
	5:{
		"NAME":"Self Emolate",
		"BASE DAMAGE":1,
		"ASPECT": ELEMENT.Fire,
		"IMPACT TYPE": "PHYSICAL",
		"TYPE":"ATTACK",
		
		"MIN BONUS":1.9,
		"MAX BONUS": 2.2,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":0,
		"MAGIC METER COST":1,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.SELF,
		},
	6:{
		"NAME":"RAH RAH",
		"BASE DAMAGE":1,
		"ASPECT": ELEMENT.Mundane,
		"IMPACT TYPE": "PHYSICAL",
		"TYPE":"SUPPORT",
		"DURATION":3,
		"STAT": "ATTACK",
		"STAT MOD": 1.5,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":0,
		"MAGIC METER COST":1,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.ALLY,
		},
	7:{
		"NAME":"Brace For Impact",
		"BASE DAMAGE":1,
		"ASPECT": ELEMENT.Mundane,
		"IMPACT TYPE": "PHYSICAL",
		"TYPE":"DEFEND",
		"DURATION":3,
		"STAT": "DEFENSE",
		"STAT MOD": 1.5,
		"LOOTING MODIFIER":0,
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":0,
		"MAGIC METER COST":1,
		"PLAYER AFFINITY":0,
		"TARGET":TARGET.SELF,
		
	}
	
	}

func scale_up(golem:Dictionary,scale:int=2)->Dictionary:
	if golem != null:
		golem["HP"] = golem["HP"]*scale
		golem["ATTACK"] = golem["ATTACK"]*scale
		golem["DEFENSE"] = golem["DEFENSE"]*scale
		golem["MAGIC ATTACK"] = golem["MAGIC ATTACK"]*scale
		golem["MAGIC DEFENSE"] = golem["MAGIC DEFENSE"]*scale
		golem["SPEED"] = golem["SPEED"]*scale
		golem["ACTION METER"] = golem["ACTION METER"]*scale
		golem["MAGIC METER"] = golem["MAGIC METER"]*scale
		if golem.has("CURRENT HP"):
			golem["CURRENT HP"] = golem["HP"]
			golem["CURRENT ACTION METER"] = golem["ACTION METER"]
			golem["CURRENT MAGIC METER"] = golem["MAGIC METER"]
	return golem
	
