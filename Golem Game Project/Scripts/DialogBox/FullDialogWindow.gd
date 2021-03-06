extends Control

#Text speed determines the speed of the text written. 0 = instant


onready var playerPortrait = $PlayerPortrait
onready var speakerPortrait = $SpeakerPortrait
onready var conversationWindow = $DialogWindow/DialogTexture/Conversation
onready var conversationSpeaker = $DialogWindow/Speaker/SpeakerNameTexture/SpeakerName
onready var Dialog = $DialogWindow
onready var NextButton = $NextButton
onready var ConfirmationWindow = $ConfirmationWindow
onready var AutoTimer = $AutoTimer
onready var BackgroundNode = $Background
onready var animationPlayer = $AnimationPlayer
#onready var backgrounds = {
#	"AlleyWay" : "res://Backgrounds/AlleyWay.png",
#	"Mall" : "res://Backgrounds/Mall.png",
#	"Park" : "res://Backgrounds/Park.png",
#	"Neighbourhood" : "res://Backgrounds/Park.png",
#
#}

#onready var sceneToLoad = 0
var playerName 
var playerGender 
var playerAvatar

var dialogContent = Array ()
var speakerNameContent = Array()
var playerPosition = 0
var dialogCount = 0
var currentlyAnimating = false;
var waitingForSelection = false;

var autoJustTurnedOn = false;
enum {regular, pause, choice, passing, loading}
var gameState = regular   ## Helps determine if it's regular mode, the game is paused, or a choice is given
var previousState = regular ##Lets it toggle back to it's previous state

var emotionStates = ["???","Happy","Surprised","Sad","Angry","Defeat","Default"];
var currentEmotions = []

var button_positions = [];

var playerChoices = [];

var choiceCount = 0

var lineCount = 0
var lineDataDict = {}
var dataTypesPerLine = {}
 
var text_speed = 1
var auto_speed = 1
var auto_state = false

signal playerAnimation
signal speakerAnimation
signal dialogDone
var activeSection = true ## if path in text file doesn't match up, will skip through lines

var changingScene = false;
# Called when the node enters the scene tree for the first time.
func _ready():
#	print (int("a"))
#	print (int("b"))
#	print (int("A"))
#	print (int("B"))
	text_speed = Settings.text_speed
	auto_speed = Settings.auto_speed
	auto_state = Settings.auto_state
#
	playerName = GlobalPlayer.playerName
	playerGender = GlobalPlayer.playerGender
	playerAvatar = GlobalPlayer.playerAvatar
#
#	debug();
#	Dialog.update_Auto(auto_state);
#	button_positions = Dialog.button_hitboxes();
#	var dialogFile = DialogStorage.VNDialogToLoad
#	##Troubelshooting
	animationPlayer.play("Slide_In_Dialog")
#	updateBackground();
#	update_dialog(speakerNameContent[playerPosition],dialogContent[playerPosition],currentEmotions[playerPosition]);
#	text_speed = Settings.text_speed;
#	auto_speed = Settings.auto_speed;
#	auto_state = Settings.auto_state;
#	Dialog.update_Auto(auto_state);
#
#	fade_in()

	pass # Replace with function body.

func updateBackground():
	var location = DialogStorage.VNBackground;
	BackgroundNode.texture = load(location)
	
func convertTextVariables (string) -> String:
	if string == "Name":
		return playerName
#	elif string == "Background":
#		return PlayerGameSave.playerBackground
	return ""
	
func parse_square_brackets(dialogText,lineNumber):
	var countSlashes =0
	var areThereCharactersOutsideSquareBracket = false;
	var numbered_choice = false;
	var contentSquareBracketString = "";
	var finalString = ""
	var insideBracket = false;
	var skipDialog = false;
	var choices = [] ## determined by [number] and text
	var choiceNumbers = []
	var choiceString = ""
	var newScript = false ## determined by [/****/]
	var variableText = ""
	var variableState = false;
	for i in dialogText:
		var character = dialogText.left(1);
		if character == "{":
			variableState = true
		elif character == "}":
			variableState = false
			if numbered_choice:
				choiceString += convertTextVariables(variableText)
			elif insideBracket:
				contentSquareBracketString += convertTextVariables(variableText)
			else:
				finalString += convertTextVariables(variableText)
				areThereCharactersOutsideSquareBracket = true
			variableText = ""
			
		elif variableState:
			variableText += character
		elif character == "[":
			insideBracket = true;
			if numbered_choice == true and choiceString != "":
				choices.append(choiceString)
				choiceString = ""
		elif character == "]":
			if !newScript:
				if countSlashes == 2: ### bracket has found that this would be a gender statement
					finalString += player_gendered_Dictionary(contentSquareBracketString);
				elif countSlashes == 0: ### choice
					if int(contentSquareBracketString) != 0:
						numbered_choice = true;
						choiceNumbers.append(int(contentSquareBracketString))
						choiceString += contentSquareBracketString + ". "
						contentSquareBracketString = ""
	#				elif numbered_choice and int(contentSquareBracketString) <= 5:
	#					choiceNumbers.append(int(contentSquareBracketString))
	#					choiceString += contentSquareBracketString + ". "
	#					contentSquareBracketString=""
					else:
						print("Unable to determine value in []")
				
			insideBracket = false
		elif insideBracket and character == "/":
			countSlashes += 1;
			contentSquareBracketString += character;
		elif insideBracket and character == "\\":
			newScript = true;
			
		elif insideBracket:
			contentSquareBracketString += character;
		elif numbered_choice and character == "&" and areThereCharactersOutsideSquareBracket == false:
			if !dataTypesPerLine.has(lineNumber):
				lineDataDict[lineNumber]=choiceNumbers
				choiceNumbers.empty();
			else:
				lineDataDict[lineNumber].append(choiceNumbers);
				choiceNumbers.empty();
		else:
			if numbered_choice:
				choiceString += character
			elif variableState:
				pass
				
			else:
				finalString += character;
				areThereCharactersOutsideSquareBracket = true;
		if dialogText.left(2) != null:
			dialogText = dialogText.right(1)
	
	if newScript:
		dataTypesPerLine[lineNumber] = "loadNewScript"
		lineDataDict[lineNumber] = contentSquareBracketString
		return ""
	elif numbered_choice and !choices.empty():
		dataTypesPerLine[lineNumber] = "choiceToMake"
		choices.append(choiceString)
		lineDataDict[lineNumber] = choices
		if areThereCharactersOutsideSquareBracket:
			return finalString
	elif numbered_choice and choices.empty():
		dataTypesPerLine[lineNumber] = "pathCheck"
		lineDataDict[lineNumber]=choiceNumbers
	elif areThereCharactersOutsideSquareBracket:
		return finalString;
	elif contentSquareBracketString == "Resume":
		dataTypesPerLine[lineNumber] = "pathCheck"
		lineDataDict[lineNumber] = "Resume"
		
	return "Error reading Square Brackets"
	
		
#func parse_gender_brackets (dialogText):
#	print (dialogText)
#	var genderString = "";
#	var inGenderString = false;
#	var contentString = ""
#	for i in dialogText.length():
#
#		var character = dialogText.left(1);
#		if character == "[":
#			inGenderString = true;
#
#		elif character == "]":
#			inGenderString = false;
#			contentString += player_gendered_Dictionary(genderString);
#			inGenderString = "";
#		elif inGenderString:
#			genderString += character
#		else:
#			contentString += character;
#		dialogText = dialogText.right(1)
#	return contentString;

##Takes the dialogs, and parsing it out to two parts left of ":" and right of ":"
##Brackets are handled by the functions after, to cycle through the info in brackets
func load_dialogs(file_location):
	var d = File.new();
	var error = d.open(file_location,File.READ)
	if error != OK:
		print (error, " when attempting to open \"",file_location,"\"")
		return
#	troubleshooting
#	var index = 0
	var nameofSpeaker = "";
	var dialog = "";
	dialogCount = 0;
	while not d.eof_reached():
		var line = d.get_line();
		lineCount += 1;
		var troubleshootingline = line;
		var contentString = "";
		var found_split = false;
		var charcount = line.length()
		
		var genderString = "";
		var inGenderString = false;
		if line != "":
			for i in charcount:
				var character = line.left(1);
#				print ("character = ",character)
				##Finding split between Speaker and Dialog
				if !found_split:
					if character != null and i+1 != charcount:
#						print ("i(",i,") != charcount(",charcount,") -> ", i+1 != charcount)
						if character != ":":
							contentString += character;
							line = line.right(1);
						elif line.left(2) != null:
							if line.left(2) == "/": ## New path
								newPath(line.right(2))
								return
							else:
								nameofSpeaker = contentString
								line= line.right(2);
								found_split = true;
								contentString = "";
#							else:
#								contentString += line.left(2);
#								line = line.right(2)
#						print (character)
					else:
						dialog=contentString+character;
#						print ("character null = ", dialog)
						break;
				else:
					if line != null:
						dialog = line;
#					print ("found split = ", dialog)
					break;
			dialog = parse_square_brackets(dialog,lineCount-1); ##parsing the speach, if there is no name, then processes square brackted
#			print ("name of speaker = ", nameofSpeaker);
			if nameofSpeaker == "PC":
				nameofSpeaker = playerName
			nameofSpeaker = emotion_check(nameofSpeaker);
			speakerNameContent.append(nameofSpeaker)
#			if dialog != "" and dialog != null:
#				dialogContent.append(dialog.replace("\\n", "\n\n"))
#				dialogCount += 1;
			dialogContent.append(dialog.replace("\\n", "\n\n"))
			dialogCount += 1;
				
	update_dialog(speakerNameContent[playerPosition],dialogContent[playerPosition],currentEmotions[playerPosition])
#troubleshooting
#		line += " "
#		print(troubleshootingline + " " + str(index))
#		print(speakerNameContent[index],":")
#		print(dialogContent[index])
#		index += 1
	d.close()
	

func determine_Gender_value ():
	if playerGender == "Ambiguous":
		return 0;
	elif playerGender == "Man":
		return 1;
	elif playerGender == "Woman":
		return 2;
	print ("error - Gender does not match");


#Gendered word Choice  ambiguousWord = 0, maleWord = 1, femaleWord = 2
func player_gendered_Dictionary (genderWordsToPick):
#	print ("Gender words sifting = " + genderWordsToPick)
	var replacementWord;
#	var wordsToChooseFrom = [];
	var currentWord = "";
#	var ambiguousWord = 0
#	var maleWord = 1
#	var femaleWord = 2
	var wordCount = 0;
	var genderWordToFind = determine_Gender_value();
	var characterCount = genderWordsToPick.length();
	for i in characterCount+1:
		var character = genderWordsToPick.left(1);
#		print ("i = ",i,"  Character Count = ",characterCount)
		if character == "/" or character == "]" or i == characterCount:
			if wordCount == genderWordToFind:
#				print (currentWord)
				return currentWord
			else:
				currentWord = "";
				wordCount += 1;
		else:
			currentWord += character;
		genderWordsToPick = genderWordsToPick.right(1);
	print ("did not find gendered word")
			
	
	
func emotion_check(speakerText):
#	print ("Emotion Check Words = " + speakerText)
	var speakerName = ""
	var emotion = ""
	var has_emotion = false
	var reading_emotion = false
	for i in speakerText.length()+1:
		var character = speakerText.left(1);
#		print ("i = ",i,"  Character = ",character)
		if character == "[":
			has_emotion = true
			reading_emotion = true
		elif reading_emotion and character == "]":
			reading_emotion = false;
		elif reading_emotion:
			emotion += character
		else:
			speakerName += character
		if speakerText.left(2) != null:
			speakerText = speakerText.right(1)
		else:
			speakerText = null
	if has_emotion:
		var foundEmotion = false
		for i in emotionStates.size():
			var checkState = str(emotionStates[i]);
			if checkState in emotion:
				currentEmotions.append(checkState);
				foundEmotion = true
		if !foundEmotion:
#			print ("Error: No Emotion found")
			currentEmotions.append("Default")
	if !has_emotion:
		currentEmotions.append("Default")
	#	print ("speakerText after emotions = "+speakerText)
	return speakerName;
		
	pass

func checkActiveDialog(position):
	if dataTypesPerLine.has(position):
		if dataTypesPerLine[position] == "choiceToMake":
			previousState = gameState
			gameState = choice
		elif dataTypesPerLine[position] == "loadNewScript":
			previousState = gameState
			gameState = loading
			pass
func checkPath (position):
	var matching = false;
	if dataTypesPerLine.has(position):
		if dataTypesPerLine[position] == "pathCheck":
			var arrayCheck = lineDataDict[position]
			
			if arrayCheck is String:
				if arrayCheck == "Resume":
					matching = true
				
			elif arrayCheck[0] is Array:
				for i in arrayCheck.size():
					var returned = arrayCompare(playerChoices,arrayCheck[i]);
					if matching or returned == true:
						matching = true
			else:
				matching = arrayCompare(playerChoices,arrayCheck)
			if matching:
				previousState = gameState
				gameState = regular
			else:
				previousState = gameState
				gameState = passing
	return matching

func arrayCompare (array1,array2) -> bool :
	if array1.size() != array2.size():
		return false
	var matching = true
	for i in array1.size():
		if array1[i] != array2[i]:
			matching = false;
	return matching;
func play_next_dialog():
	playerPosition += 1;
	save_state();
	checkActiveDialog(playerPosition)
#	print ("Player Position = ",playerPosition)
	if checkPath(playerPosition):
		play_next_dialog()
	elif gameState == passing:
		play_next_dialog();
	elif gameState == loading:
		save_settings()
		newPath(lineDataDict[playerPosition])
	elif isDoneDialog():
		end_dialog()
	else:
		update_dialog(speakerNameContent[playerPosition],dialogContent[playerPosition],currentEmotions[playerPosition])
		pass
func isDoneDialog():
	if speakerNameContent.size()<=playerPosition or dialogContent.size()<=playerPosition:
		return true
	return false
		
#update to animation states at later dates
func update_dialog(speaker,conversation,emotion):
#	print ("updat e dialoge speaker " + speaker)
	NextButton.hide();
	if emotion != "Unchanged":
		if emotion == "???":
			speakerPortrait.modulate = Color(0,0,0)
			emotion = "Default"
		elif emotion != "???":
			speakerPortrait.modulate = Color(1,1,1)
		if !emotionStates.has(emotion):
			emotion = "Default"
#			print ("other emotions called")
	
	var textureFileLocation = "res://Assets/Portraits/"
	if speaker == playerName:
		textureFileLocation += "PlayerCharacter/"+emotion+"_PlayerCharacter.png"
	else:
		textureFileLocation += speaker+"/"+emotion+"_"+speaker+".png"

	if speaker == "Narrator":
		emit_signal("playerAnimation","hide")
		emit_signal("speakerAnimation","hide")

	elif speaker == playerName:
		emit_signal("playerAnimation","show",speaker,textureFileLocation)
		emit_signal("speakerAnimation","hide")
		speaker = playerName
			
	else:
		emit_signal("playerAnimation","hide")
		emit_signal("speakerAnimation","show",speaker,textureFileLocation)
#		conversationSpeaker.show();
	
	if !lineDataDict.has(playerPosition):
		conversationWindow.show(); #calling show each time just incase states change elsewere.	
		conversationSpeaker.text = speaker;
		conversationWindow.text = conversation;
		currentlyAnimating = true;
		Dialog.new_Dialog(speaker,conversation,text_speed)
	
	else:
		previousState = gameState
		gameState = choice
		Dialog.new_Choices(speaker,lineDataDict[playerPosition])
		lineDataDict.erase(playerPosition)
	
	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func newPath (pathWay):
	DialogStorage.newDialog(pathWay)
	fade_out()

func _process(delta):
	if gameState == regular:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_focus_next") or Input.is_action_just_pressed("ui_focus_prev"):
#			if !is_a_button(get_global_mouse_position()):
			if currentlyAnimating:
				Dialog.done_Writing()
			elif waitingForSelection:
				pass
			else:
				play_next_dialog();
		elif !currentlyAnimating and auto_state and AutoTimer.time_left == 0 and autoJustTurnedOn:
			AutoTimer.start();
			autoJustTurnedOn = false;
		
		
## button_positions is pulled from Dialog Screen, and is global position with:
## x start, y start, x end, y end.
func is_a_button(position):
	for i in button_positions.size():
		if button_positions[i][0] <= position.x and button_positions[i][2] >= position.x:
			if button_positions[i][1] <= position.y and button_positions[i][3] >= position.y:
				return true;
	return false
	
func save_settings():
	pass
###Post Next Button as we are ready to move on
func next_button_ready():
	NextButton.show()
	pass

func _on_DialogWindow_writingFinished():
	currentlyAnimating = false;
	if auto_state:
		AutoTimer.wait_time = auto_speed*.05
		AutoTimer.start();
	else:
		next_button_ready()
	pass # Replace with function body.


func _on_AutoTimer_timeout():
	play_next_dialog();

func _on_NextButton_pressed():
	play_next_dialog();
	pass # Replace with function body.

func _on_DialogWindow_AutoPlay():
	auto_state = !auto_state;
	autoJustTurnedOn=true
	pass # Replace with function body.


func _on_DialogWindow_Settings():
	pass # Replace with function body.


func _on_DialogWindow_Skip():
	ConfirmationWindow.show();
	pause(pause);
	pass # Replace with function body.

func pause(state):
	previousState = gameState
	gameState=state;
	Dialog.pause(gameState);


func change_to_next_scene():
#	print ("change scene function here")
	save_settings()
	pass

func save_state():
#	PlayerGameSave.playerSave = playerPosition;
#	PlayerGameSave.saveGame()
	pass

func _on_ConfirmationWindow_confirmation(confirmation):
	if confirmation:
		end_dialog();
	else:
		ConfirmationWindow.hide();
		pause(previousState)

	pass # Replace with function body.

func debug():
	playerName = "Connor"
	playerGender = "Man"


func _on_DialogWindow_choiceMade(choice):
	previousState = gameState
	gameState = regular
	playerChoices.append(choice)
	play_next_dialog()
	pass # Replace with function body.

#
func fade_in():
	$BlackOut/BlackOutTween.interpolate_property($BlackOut,"modulate",Color(1,1,1,1),Color(1,1,1,0),1.0)
	$BlackOut/BlackOutTween.start()
func _on_VisualNovelWindow_playerAnimation():
	pass # Replace with function body.

func fade_out(changeScene = true):
	$BlackOut.show()
	$BlackOut/BlackOutTween.interpolate_property($BlackOut,"modulate",Color(1,1,1,0),Color(1,1,1,1),1.0)
	$BlackOut/BlackOutTween.start()
	if changeScene:
		changingScene = true

func _on_BlackOutTween_tween_completed(object, key):
	if object.modulate == Color(1,1,1,0):
		$BlackOut.hide()
	elif object.modulate ==Color(1,1,1,1):
		get_tree().change_scene("res://Scenes/VisualNovelWindow.tscn")
	pass # Replace with function body.
func end_dialog():
	emit_signal("dialogDone")
	animationPlayer.play("Slide_Out_Dialog")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Slide_Out_Dialog":
		self.queue_free()
	pass # Replace with function body.
