extends Control

onready var tween = $Tween
onready var title = $VBoxContainer/Title
onready var heading = $VBoxContainer/Heading
onready var onScreenTimer = $OnScreenTimer
onready var stinger = $Stinger
export (float) var typingSpeed = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play(textToDisplayPrimary:String, textToDisplaySecondary:String):
	
	title.text = textToDisplayPrimary
	heading.text = "- "+ textToDisplaySecondary +" -"
	title.percent_visible = 0
	heading.percent_visible = 0
	tween.interpolate_property(title,"percent_visible",0,1,typingSpeed,Tween.TRANS_LINEAR)
	tween.interpolate_property(title,"modulate:a",0,.80,1,Tween.TRANS_LINEAR)
	tween.start()
	if stinger.stream != null:
		stinger.play()


func _on_Tween_tween_completed(object, key):
	if object == title and key == ":percent_visible":
		tween.interpolate_property(heading,"percent_visible",0,1,typingSpeed,Tween.TRANS_LINEAR)
		tween.interpolate_property(heading,"modulate:a",0,.80,1,Tween.TRANS_LINEAR)
		tween.start()
	elif object == heading and key == ":percent_visible":
		onScreenTimer.start()


func _on_OnScreenTimer_timeout():
	tween.interpolate_property(title,"modulate:a",.80,0,3,Tween.TRANS_LINEAR)
	tween.interpolate_property(heading,"modulate:a",.80,0,3,Tween.TRANS_LINEAR)
	tween.start()
	pass # Replace with function body.
