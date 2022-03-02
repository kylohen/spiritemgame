extends Control

onready var playerOptions = $UIChoices/Options
onready var playerSkills = $UIChoices/PlayerSkills
onready var enemyGraphics = $EnemyGraphics
onready var playerGraphics = $PlayerGraphics
onready var sceneSetup = $SceneSetup

var playerSelection  = 3

var enemyFront = {}
var enemyBack = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_player_choice(newChoice):
	if newChoice >=1 and newChoice <= 2:
		var newOption = newChoice-1
		playerSkills.get_child(newOption).modulate.a = 1
	elif newChoice >= 3 and newChoice<=6:
		var newOption = newChoice-3
		playerOptions.get_child(newOption).modulate.a = 1
	pass
func clear_player_choice(oldChoice):
	if oldChoice >=1 and oldChoice <= 2:
		var newOption = oldChoice-1
		playerSkills.get_child(newOption).modulate.a = 0
	elif oldChoice >= 3 and oldChoice<=6:
		var newOption = oldChoice-3
		playerOptions.get_child(newOption).modulate.a = 0
	pass
	pass

func select_player_choice(newChoice):
	
	pass
	
func start_encounter(enemyNode):
	
	enemyGraphics.get_node("EnemyBackingFront/EnemyName").text = enemyNode.enemyName
	enemyFront = enemyNode.statBlock
	enemyGraphics.get_node("EnemySpriteFront").texture = load (enemyFront["frontSprite"])
	
	if enemyNode.enemyName == "":
		if enemyNode.isElite == true:
			sceneSetup.play("1v1 Elite")
		else:
			sceneSetup.play("1v1")
	else:
		enemyGraphics.get_node("EnemyBackingBack/EnemyName").text = enemyNode.enemyBackName
		enemyBack = enemyNode.statBlockBack
		enemyGraphics.get_node("EnemySpriteBack").texture = load (enemyBack["frontSprite"])
		pass
	
func ui_cancel(arrowKeySelection = false):
	
	pass
func move_right():
	clear_player_choice(playerSelection)
	if playerSelection == 1:
		playerSelection = 2
	elif playerSelection == 2:
		playerSelection = 1
	else: ui_accept(true)
	update_player_choice(playerSelection)
func move_left():
	clear_player_choice(playerSelection)
	if playerSelection == 1:
		playerSelection = 2
	elif playerSelection == 2:
		playerSelection = 1
	else: ui_cancel(true)
	update_player_choice(playerSelection)
	
func move_up():
	clear_player_choice(playerSelection)
	if playerSelection == 1:
		playerSelection = 6
	else: playerSelection -= 1
	update_player_choice(playerSelection)
	
func move_down():
	clear_player_choice(playerSelection)
	if playerSelection == 6:
		playerSelection = 1
	else: playerSelection += 1
	update_player_choice(playerSelection)
	
func ui_accept(arrowKeySelection = false):
	pass
