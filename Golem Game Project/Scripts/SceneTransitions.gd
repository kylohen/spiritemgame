extends Control

onready var transitionPlayer = $AnimatedSprite
var currentTransition
signal transitionDone
var previousPLAYSTATE
export (bool) var blackScreen = false 


# Called when the node enters the scene tree for the first time.
func _ready():
	if blackScreen:
		transitionPlayer.animation = "radial_wipe_on"
	pass # Replace with function body.

func run_Transition(animationToDo):
	if animationToDo == "radial_wipe_off":
		self.show()
		currentTransition = animationToDo
		transitionPlayer.animation = "radial_wipe_off"
		
#		transitionPlayer.flip_h = false
		transitionPlayer.play("radial_wipe_off")
		previousPLAYSTATE = GlobalPlayer.currentPLAYSTATE 
		GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.PAUSE)
		GlobalPlayer.isInAnimation = true
	elif animationToDo == "radial_wipe_on":
		self.show()
		currentTransition = animationToDo
#		transitionPlayer.flip_h = true
		transitionPlayer.animation = "radial_wipe_on"
		transitionPlayer.play("radial_wipe_on")
		previousPLAYSTATE = GlobalPlayer.currentPLAYSTATE 
		GlobalPlayer.update_PLAYSTATE(GlobalPlayer.PLAYSTATE.PAUSE)
		GlobalPlayer.isInAnimation = true


func _on_AnimatedSprite_animation_finished():
	self.hide()
	GlobalPlayer.update_PLAYSTATE(previousPLAYSTATE)
	GlobalPlayer.isInAnimation = false
	if currentTransition == "radial_wipe_off":
		emit_signal("transitionDone", currentTransition)
	elif currentTransition == "radial_wipe_on":
		emit_signal("transitionDone", currentTransition)
	pass # Replace with function body.
