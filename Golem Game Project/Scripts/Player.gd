extends KinematicBody2D

export var walk_speed = 4.0

##Player must always be a child of the grid world
onready var grid = get_parent()
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var playerSFX = $PlayerSFX

enum PlayerState {IDLE, TURNING, WALKING}
enum FacingDirection {LEFT, RIGHT, UP, DOWN}

var player_state = PlayerState.IDLE
var facing_direction = Vector2.DOWN
var initial_position = Vector2(1, 1)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0
onready var STARTPOS = initial_position*WorldConductor.TILE_SIZE 

signal useToolOnBlock
signal useItemOnBlock
signal newPosForCamera
signal player_action_occured
##Keeping Grid Coords seperate until the nuances of the movement is understood
onready var gridCoords = initial_position
signal cameraState
var isActive = true 
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_tree.active = true
	position = initial_position*WorldConductor.TILE_SIZE 
	emit_signal("newPosForCamera",self.position)
	
func _physics_process(delta):
	if player_state == PlayerState.TURNING:
		return
	elif is_moving == false:
		process_player_input ()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false
		
func changeActiveState (newState = !isActive):
	isActive = newState
	emit_signal("cameraState",newState)
	
func process_player_input():
	if isActive:
		if GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME):
			if input_direction.y == 0:
				input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
			if input_direction.x == 0:
				input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
			###Using tool on block
			if Input.is_action_just_pressed("ui_select"):
				emit_signal("useToolOnBlock", gridCoords + facing_direction)
				emit_signal("player_action_occured",initial_position/WorldConductor.TILE_SIZE )
				need_animation()
			if input_direction != Vector2.ZERO:
				anim_tree.set("parameters/Idle/blend_position", input_direction)
				anim_tree.set("parameters/Walk/blend_position", input_direction)
				anim_tree.set("parameters/Turn/blend_position", input_direction)
				
				if need_to_turn():
					player_state = PlayerState.TURNING
					anim_state.travel("Turn")
				elif grid.is_Open_Tile(gridCoords,input_direction):
					initial_position = position
					is_moving = true
					emit_signal("player_action_occured",initial_position/WorldConductor.TILE_SIZE )
			else:
				anim_state.travel("Idle")
		else:
			anim_state.travel("Idle")

#func reset_position():
#	position = STARTPOS
#	update_grid_pos_based_of_pixel_pos (position)
#
#func update_grid_pos_based_of_pixel_pos (newPos):
#	initial_position = newPos/TILE_SIZE
#	gridCoords = initial_position
#func check_cave_terrain(boolState:bool):
#	if boolState:
#		grid = get_parent().get_node("Cave")
#	else:
#		grid = get_parent()
#		pass
		
func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = Vector2.LEFT
	elif input_direction.x > 0:
		new_facing_direction = Vector2.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = Vector2.UP
	elif input_direction.y > 0:
		new_facing_direction = Vector2.DOWN
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false

func finished_turning():
	player_state = PlayerState.IDLE

func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (WorldConductor.TILE_SIZE * input_direction)
		emit_signal("newPosForCamera",self.position)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		gridCoords += input_direction
		playerSFX.play()
	else:
		position = initial_position + (WorldConductor.TILE_SIZE * input_direction * percent_moved_to_next_tile)
		emit_signal("newPosForCamera",self.position)
		playerSFX.stop()



########TO BE REMOVED WHEN ANIMATIONS ARE INTRODUCED##############


#func _process(delta):
#	pass
func need_animation():
	$ToBeDeleted.show()
	$ToBeDeleted/TimerToBeDeleted.start()
	playerSFX.play()

func _on_TimerToBeDeleted_timeout():
	$ToBeDeleted.hide()
	pass # Replace with function body.


func _on_WorldMap_Field_loot_received(lootType,quantityOfLoot):
	GlobalPlayer.add_loot(lootType,quantityOfLoot)
	pass # Replace with function body.




func _on_PlayerUI_useItem(itemID,itemTexture,itemIndex):
	emit_signal("useItemOnBlock",itemID,itemTexture,gridCoords + facing_direction,itemIndex)
	pass # Replace with function body.


func _on_Cave_loot_received(lootType,quantityOfLoot):
	GlobalPlayer.add_loot(lootType,quantityOfLoot)
	pass # Replace with function body.


