extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_newPosForCamera(newPos):
	self.position = newPos
	pass # Replace with function body.


func _on_Player_cameraState(newState):
	self.current = newState
	pass # Replace with function body.
