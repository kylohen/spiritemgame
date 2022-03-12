extends Control

onready var healthBar = $VBoxContainer/HealthBarContainer/HealthBar
onready var actionMeter=$VBoxContainer/MeterContainer/ActionMeter
onready var magicMeter = $VBoxContainer/MeterContainer/MagicMeter
onready var aspectType = $VBoxContainer/HealthBarContainer/Type
onready var barTween = $BarTween

var currentHealth
var maxHealth
var currentAction
var maxAction
var currentMagic
var maxMagic

export var isPlayer = false


func _ready():
	if isPlayer:
		pass
	else:
		actionMeter.modulate.a = 0
		magicMeter.modulate.a = 0
	pass # Replace with function body.

func update_aspect(newAspect):
	aspectType.show()
	if StatBlocks.aspectSprite.has(newAspect):
		aspectType.texture = load(StatBlocks.aspectSprite[newAspect])
	else: aspectType.hide()
func initialize(health,healthMax,action,actionMax,magic,magicMax):
	update_ui_health_bar(health,healthMax)
	update_action(action,actionMax)
	update_magic(magic,magicMax)

func update_ui_health_bar(health,healthMax = maxHealth):
	currentHealth = health
	maxHealth = healthMax
	
	healthBar.max_value = maxHealth
	
	barTween.interpolate_property(healthBar,"value",healthBar.value,currentHealth,1)
	barTween.start()

func update_action(action,actionMax = maxAction):
	
	currentAction = action
	maxAction = actionMax
	
	actionMeter.max_value = maxAction
	
	barTween.interpolate_property(actionMeter,"value",actionMeter.value,currentAction,1)
	barTween.start()
func update_magic(magic,magicMax = maxMagic):
	
	currentMagic = magic
	maxMagic = magicMax
	
	magicMeter.max_value = maxMagic
	
	barTween.interpolate_property(magicMeter,"value",magicMeter.value,currentMagic,1)
	barTween.start()
	
func update_ui_action_bars(costOfAction,CostOfMagic):
	
	currentAction -= costOfAction
	if currentAction < 0:
		currentAction = 0
	barTween.interpolate_property(actionMeter,"value",actionMeter.value,currentAction,1)
	barTween.start()

	currentMagic -= CostOfMagic
	if currentMagic < 0:
		currentMagic = 0
	barTween.interpolate_property(magicMeter,"value",magicMeter.value,currentMagic,1)
	barTween.start()
