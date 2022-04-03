# spiritemgame

#### How to add golems and voids to the game? (sprite, name, initial stat block, starting moveset, stat upgrade scaling, upgrade form [haya-haybo-haybur ect])
Adding Golems can be done in the Singleton Folder under StatBlocks. You can copy and paste any existing golem from enemyStatBlocks (Voids) and playerGolemBaseStatBlocks (Player Golems)

	#####GOLEM DICTIONARY STRUCTURE#####
	{
	"NAME": ##STRING Name of GOLEM
	"Type1": ELEMENT.Void,    ##UNUSED AT THIS TIME
	"Type2": ELEMENT.Nature,  ##UNUSED AT THIS TIME
	"frontSprite": ##String location of Art Asset
	"backSprite":##String location of Art Asset - only for playerGolems
	"PARTY ICON":##String location of Art Asset - only for playerGolems
	"HP": ##Int for max HP
	"ATTACK":##Int for Attack
	"DEFENSE":##Int for DEFENSE
	"MAGIC ATTACK": ##Int for MAGIC ATTACK
	"MAGIC DEFENSE":##Int for MAGIC DEFENSE
	"SPEED":##Int for SPEED
	"ASPECT":# enum of type, e.g ELEMENT.Lightning
	"MODIFIERS":{}, #empty dict to be used by battle logic
	"DAMAGE OVER TIME":{},#empty dict to be used by battle logic
	"ACTION METER": ##Int for max ACTION
	"MAGIC METER": ##Int for max MAGIC
	"CURRENT ACTION": ##Int for CURRENT ACTION
	"CURRENT MAGIC": ##Int forCURRENT MAGIC
	"AFFINITY":##Int for AFFINITY
	"LEVEL":##Int for LEVEL
	"NORMAL LOOT DROP": ### Dictionary of ItemID: Quantity e.g {"Dust":3}
	"RARE LOOT DROP":### Dictionary of ItemID: Quantity e.g {"Dust":3}
	"ATTACK SKILLS": ### Dictionary of Skill Slot and SkillID {"SKILL1":3,"SKILL2":2,"SKILL3":null,"SKILL4":null,},
	"SUPPORT SKILLS":### Dictionary of Skill Slot and SkillID {"SKILL1":3,"SKILL2":2,"SKILL3":null,"SKILL4":null,},
	"DEFEND SKILLS":### Dictionary of Skill Slot and SkillID {"SKILL1":3,"SKILL2":2,"SKILL3":null,"SKILL4":null,},
	}
	
Please note that advancements  between golems has not been configured, but another entry in this dictionary could easily set up some logic to advance/change the golems in your care
	
	
#### How to add items and crafting recipes

Adding Recipes can be done in the Singleton Folder under StatBlocks. You can copy and paste any existing recipe from golemRecipes (Making Golems) and ItemRecipeDict (Making Items) 

	golemRecipes= {
	##String of Golem's Name : ##Dictionary of {##String of ItemID : ##Int of Qty needed}
	##EXAMPLE##
	{"StrawBoy" :{
		"Straw" : 4
	}

Please note that all recipes  require 1x golem core and are checked at creation time. If you need more than 1 golem core, a core can be added to this list, but will need to be placed on the pedestal vs. automatically being used in the building of a golem



ItemRecipeDict = {
	##Int that is a unique ID : {#String of ItemID:#Dictionary of {##String of ItemID : ##Int of Qty needed}
	}
	
	##EXAMPLE##
	0:{
		"Straw Bundle":{
			"Straw":9,
			},
		},
	1:{
		"Golem Core" : {
			"Aspect Crystal": 1,
			"Runic Matrix" : 1,
			},
		},

Please note that as of writing, Recipes only have enough space for 2x requirements before text becomes messy

#### How to add new Items

Located in the ItemTable Singleton, it's broken into two lists, UseItemList and ResourceItemList. You should not duplicate any, but the UseItemList is only for items you would use on Golems or Voids.
	###EXAMPLE OF USE####
	var UseItemList = {
		"Repair Dust" #NAME of item :{
			"USE":"Golem", #Target
			"STAT":"CURRENT HP", #Stat that will be affected
			"MODIFIERS": 25, #Stat that will go up
			"TARGET":StatBlocks.TARGET.BOTH, #BATTLE Target
			"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_repair_dust.png" #Sprite image location
		},
	}
###EXAMPLE OF RESOURCE/NOT USABLE####
	var ResourceItemList = {
		"Dust" #NAME of item :{
			"itemSprite":"res://Assets/UI/Inventory/ItemUI/sprite_item_dust.png", #Sprite image location
			},
	}
#### How to add new moves for golems and voids (name, animation, effect, categorize Atk\Def\Sup)
var skillList = {
	0 #Unique Number:{
		"NAME":"Struggle", #String
		"BASE DAMAGE":1, #Int
		"ASPECT": ELEMENT.Mundane, #Element of Skill
		"TYPE":"ATTACK", #Category of Type of Skill
		
		"MIN BONUS":.9, #rnd rang min
		"MAX BONUS": 1.2, #rnd rang min
		"IMPACT TYPE": "PHYSICAL", # String of PHYSICAL/MAGICAL to utilize the Attack/Defense and Magic Attack/Magic Defense
		"LOOTING MODIFIER":0, #adjust looting modifier 
		"CRIT PROBABILITY":1.2,
		"ACTION METER COST":1, #cost of skill to use on ACTION
		"MAGIC METER COST":0, #cost of skill to use on MAGIC
		"PLAYER AFFINITY":0, #Affinity not implemented, but would affect the effectiveness of skill
		"TARGET":TARGET.ENEMY, #enum of what the skill can target {SELF,ENEMY,ALLY,AOE_ALLY,AOE_ENEMY,BOTH}
		},
#### How to modify Generated Rooms (overworld and cave)
To affect the generation of the random World structure, in the Grid script you can adjust the way noise is generated in the makingNoise structure, or adjust the expected values to generate the tiles based off of the tiles:

	func makingNoise ():
		noise.seed = SeedGenerator.rng.randi()
		noise.octaves = 4
		noise.period = 20.0
		noise.persistence = 0.8
	
	func spawnTerrainTile (x,y):
		var randomTile = noise.get_noise_2d(x,y)
		var selectedTile = null
		if randomTile < -0.45:
			selectedTile = tileTypes.water
		elif randomTile < -0.4:
			selectedTile = tileTypes.sand
		elif randomTile <-0.37:
			selectedTile = tileTypes.clay
		elif randomTile <0.3:
			selectedTile = tileTypes.grass
		elif randomTile <0.4:
			selectedTile = tileTypes.trees
		elif randomTile <1:
			selectedTile = tileTypes.rocks
		else:
			selectedTile = tileTypes.grass
#### How to add music and sound effects for triggers (enter room, enter battle scene, use tool, Golem uses move)

In each scene there is an audio player that has a SFX and BGMusic player where appropriate. Audio controls/manager is not fully flushed out, as it's not clear how in depth and rich the audio content will be. The BattleSprites scene has it's own animation/audio section to build out as needed/seen fit

#### How to change timing of animations (text, battle scene animations, resource respawn rate, transitions)

Scenes, transitions, and battles are all animated through the AnimationPlayers located on the Scenes themselves. For BattleSprite scene, there is a timer included to give a brief pause between each action before telling the main battle scene to continue to the next step

Resource respawn rate is exactly the same, in the OverworldObject Scene, there is a RespawnTimer to adjust the respawn time.
#### How to change enemy spawning and respawning
Located in the Overworld and Cave Scenes, the Enemy Manager controls the spawning and locations. The function spawnEnemy() decides the enemy location in the overworld, and what kind of battle it is.

#### Update UI assets
Assets are located mostly in the Dictionaries  provided above, by copying the location of the file into the appropriate field, everything else is done for you.

#### How to add text to dialogue and to the lore tab

text dialog can be parsed out through a text file to automatically generate the dialog, the next press, and even the sprites and speakers on the screen.

When calling the run_Dialog function in the PlayerUI scene, include the location of the text file.

	####EXAMPLE OF THE TEXT FILE####
	Old Man: You there, {Name}, I haven't seen you since you were but a wee' [boy/girl/child]!
	[Defeat]Old Man: Ugggggggggghhhhhhhhhhhh
	
Using [] can help you include tools like emotions for speakers before their names, and using 2x slashes, you can include Gendered pronouns to match the user[Masculine/Feminine/Ambiguous]. Using {NAME} in your speaking part, will insert the player's name into the text box. 

The example above would give you a default sprite of the Old Man, then one of him defeated, presuming that there is a sprite stored using the name of the character and the emotion presented.
In this example it would be located in "res://Assets/Portraits/Old Man/" with images stored: "res://Assets/Portraits/Old Man/Default_Old Man.png" and "res://Assets/Portraits/Old Man/Defeat_Old Man.png"

Lore is within the Lore Scene, just add the text you would like to see on the page

#### Using the Seeds

To test the same generated world, copy the Seed Key State shown in your console on loading up the game, and copy it into the SeedGenerator _ready() function, and replace the randSeedNum() with your seed number
