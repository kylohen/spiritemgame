extends Node2D
onready var enemyScene = preload("res://Scenes/EnemyVoid.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerMovesToAction = 2
var currentCount = 0
signal enemy_contact
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func disable_enemies():
	pass
func enable_enemies():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawn_enemy():
	var newEnemy = enemyScene.instance()
#	var spawnPosition = Vector2(SeedGenerator.rng.randi_range(1,get_parent().gridWidth-1),SeedGenerator.rng.randi_range(1,get_parent().gridHeight-1))
	var spawnPosition = Vector2(5,5)
	newEnemy.currentGridPosition = spawnPosition

	add_child(newEnemy)
	newEnemy.connect("touch_player",self,"_on_EnemyVoid_touchPlayer")
	newEnemy.set_grid(get_parent().gridMap,get_parent().objectPlacement,get_parent().gridWidth,get_parent().gridHeight)
	newEnemy.spawn_enemy(choose_enemy(),choose_enemy())
	pass

func choose_enemy():
	return SeedGenerator.rng.randi_range(0, StatBlocks.enemyStatBlocks.size()-1)

func _on_Player_player_action_occured(playerPositionInGrid):
	currentCount +=1
	if currentCount >= playerMovesToAction:
		if get_child_count() <= 0:
			spawn_enemy()
		for i in get_child_count():
			get_child(i).move_enemy(playerPositionInGrid)
		pass # Replace with function body.
		currentCount = 0
		


func _on_EnemyVoid_touchPlayer(enemyNode):
	emit_signal("enemy_contact",enemyNode)
	pass # Replace with function body.

func disable():
	for i in self.get_child_count():
		self.get_child(i).disable()
	self.hide()
func enable():
	for i in self.get_child_count():
		self.get_child(i).enable()
	self.show()
