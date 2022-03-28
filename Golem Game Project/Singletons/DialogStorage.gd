extends Node


#onready var textureDict = {
#	"Alleyway":"res://Assets/VNBackground/Alleyway.jpg",
#	"Mall" : "res://Assets/VNBackground/Mall.png",
#	"Park" : "res://Assets/VNBackground/Park.png",
#	"Neighbourhood" : "res://Assets/VNBackground/Park.png",
#
#}
#onready var dialogToTextureDict ={
#	"Intro":"Neighbourhood",
#	"Act1":"Alleyway"
#
#}

var conversation = {
	"IntroPart1":"res://Assets/Dialog/DialogText/IntroPart1.txt"
}
var VNDialogToLoad = ""
var VNBackground = ''

var currentVNDialog = ""
# Declvaare member variables here. Examples:
# var a = 2
# var b = "text"

#func newBackground (texture):
#	if textureDict.has(texture):
#		VNBackground = textureDict[texture]
#	else:
#		print ("Error - String did not match textureDict Keys")

#func newDialog (dialog):
#	var location = "res://VN Text/"+dialog+".txt"
#	VNDialogToLoad = location
#	if dialogToTextureDict.has(dialog):
#		VNBackground = dialogToTextureDict[dialog]

# Called when the node enters the scene tree for the first time.
func _ready():
	VNDialogToLoad = conversation["IntroPart1"]
	pass # Replace with function body.

#func defaultValues ():
#	VNBackground = textureDict["Alleyway"]
#	VNDialogToLoad = "res://VN Text/Intro.txt"
#
#	currentVNDialog = "Intro"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
