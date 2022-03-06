extends Control
onready var sprite = $Sprite
onready var playerCursor = $Sprite/PlayerSelection
onready var animationPlayer =$AnimationPlayer
enum {REST,ATTACK,HIT,FLEE}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var isPlayerSprite = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if isPlayerSprite:
		self.rect_scale.x = -self.rect_scale.x
		sprite.flip_h
	pass # Replace with function body.

func animation(type):
	if type == ATTACK:
		animationPlayer.play("ATTACK")
	elif type == HIT:
		animationPlayer.play("HIT")

func load_sprite(pathToImage:String):
	sprite.texture = load(pathToImage)

func cursor_visible (state:bool):
	if state == true:
		playerCursor.modulate.a = 1
	else:
		playerCursor.modulate.a = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
