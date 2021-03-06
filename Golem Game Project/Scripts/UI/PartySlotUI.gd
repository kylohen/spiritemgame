extends Control

onready var golemSprite = $SlotBackground/Golem
onready var nameLabel = $SlotBackground/Name
onready var levelLabel = $SlotBackground/Level
onready var hpLabel = $SlotBackground/HP
onready var actionLabel = $SlotBackground/Action
onready var magicLabel = $SlotBackground/Magic

var golem = {}
var type = null



# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all_info()
	pass # Replace with function body.

func hide_all_info():
	for i in get_child(0).get_child_count():
		get_child(0).get_child(i).hide()
func show_all_info():
	for i in get_child(0).get_child_count():
		get_child(0).get_child(i).show()

func load_golem(newGolem = null):
	reset()
	if newGolem != null:
		if !newGolem.empty():
			golem = newGolem
			golemSprite.texture = load(golem["PARTY ICON"])
			nameLabel.text = golem["NAME"]
			levelLabel.text = str(golem["LEVEL"])
			hpLabel.text = str(golem["CURRENT HP"]) + "/" + str(golem["HP"])
			actionLabel.text = str(golem["CURRENT ACTION"]) + "/" + str(golem["ACTION METER"])
			magicLabel.text = str(golem["CURRENT MAGIC"]) + "/" + str(golem["MAGIC METER"])
			show_all_info()
			type = "golem"
			
	
func refresh():
	load_golem()
func reset():
	hide_all_info()
	golem = {}
	golemSprite.texture = null
	nameLabel.text = ""
	levelLabel.text = ""
	hpLabel.text = ""
	actionLabel.text = ""
	magicLabel.text = ""
	type = null
