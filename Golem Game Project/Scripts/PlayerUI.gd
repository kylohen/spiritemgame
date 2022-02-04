extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal nextTool
signal previousTool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	process_player_input();

func _next_Tool():
	emit_signal("nextTool")
	
func _previous_Tool():
	emit_signal("previousTool")

func process_player_input():
	if GlobalPlayer.is_PLAYSTATE(GlobalPlayer.PLAYSTATE.GAME):
		if Input.is_action_just_released("Next_Tool"):
			_next_Tool();
		elif Input.is_action_just_released("Previous_Tool"):
			_previous_Tool();
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
