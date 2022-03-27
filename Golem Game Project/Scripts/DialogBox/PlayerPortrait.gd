extends Control

onready var animationPlayer = $AnimationPlayer
onready var playerSprite = $TextureRect

var showing = false;
var previousSpriteLocation = ""
var previousSpeaker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func slide_in ():
	self.show()
	animationPlayer.play("Slide_In")

func slide_out ():
	animationPlayer.play("Slide_Out")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Slide_Out":
		self.hide()


func _on_VisualNovelWindow_playerAnimation(animation,speaker = "none", newTexture = "none"):
	if animation == "hide" and showing:
		showing = false;
		slide_out();
	elif animation == "show" and !showing:
		showing = true;
		if newTexture != "none" and newTexture != previousSpriteLocation:
			var imagePNG = File.new()
			if imagePNG.file_exists(newTexture):
				previousSpriteLocation = newTexture
				playerSprite.texture = load(newTexture)
				
		elif previousSpeaker != speaker:
			var location = "res://Assets/Portraits/" + speaker+"/Default_"+speaker+".png"
			previousSpriteLocation = location
			playerSprite.texture = load(location)
		slide_in();
		previousSpeaker = speaker
		slide_in();
