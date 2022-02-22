extends TextureRect

onready var fadeOutTween = $FadeOut
onready var deathTimer = $DeathTimer

onready var textLabel = $AlertLable


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	fadeOutTween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),3.0,Tween.TRANS_BACK)
	fadeOutTween.start()
	pass # Replace with function body.

func set_text(newString):
	textLabel.set_text(newString)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FadeOut_tween_all_completed():
	deathTimer.start()
	pass # Replace with function body.


func _on_DeathTimer_timeout():
	self.queue_free()
	pass # Replace with function body.

