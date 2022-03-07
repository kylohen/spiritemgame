extends Control

onready var healthBar = $VBoxContainer/HealthBarContainer/HealthBar
onready var actionMeter=$VBoxContainer/MeterContainer/ActionMeter
onready var magicMeter = $VBoxContainer/MeterContainer/MagicMeter
onready var aspectType = $VBoxContainer/HealthBarContainer/Type

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
	update_health(health,healthMax)
	update_action(action,actionMax)
	update_magic(magic,magicMax)

func update_health(health,healthMax = maxHealth):
	currentHealth = health
	maxHealth = healthMax
	
	healthBar.value = currentHealth
	healthBar.max_value = maxHealth

func update_action(action,actionMax = maxAction):
	
	currentAction = action
	maxAction = actionMax
	
	actionMeter.value = currentHealth
	actionMeter.max_value = maxHealth

func update_magic(magic,magicMax = maxMagic):
	
	currentMagic = magic
	maxMagic = magicMax
	
	magicMeter.value = currentHealth
	magicMeter.max_value = maxHealth
