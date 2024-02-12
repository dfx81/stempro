extends Control

onready var subject_panel : Panel = $Container/VBoxContainer/Menu/MarginContainer/SubjectSelector
onready var level_select : Panel = $Container/VBoxContainer/Menu/MarginContainer/LevelSelector
onready var subject_lbl : Label = $Container/VBoxContainer/Menu/MarginContainer/LevelSelector/MarginContainer/VBoxContainer/Category
onready var stage_list : GridContainer = $Container/VBoxContainer/Menu/MarginContainer/LevelSelector/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/StageList
onready var stage_btn : PackedScene = preload("res://scenes/StageBtn.tscn")
var completed_theme : Theme = preload("res://assets/themes/kenneyUI-green.tres")

var lvl_list : Array = []
var cur_level = null

func _ready():
	var today = Time.get_datetime_dict_from_system()
	today.hour = 0
	today.minute = 0
	today.second = 0
	print(today)
	var cur_seed = Time.get_unix_time_from_datetime_dict(today)
	
	if cur_seed > Globals.cur_seed:
		Globals.progress[3] = 0
		Globals.cur_seed = cur_seed
		Globals.save_score()
	
	print(str(cur_seed))
	rand_seed(cur_seed)
	#Globals.bio_questions.shuffle()
	#Globals.phys_questions.shuffle()
	#Globals.cs_questions.shuffle()
	pass

func _process(_delta):
	refresh()

func refresh():
	if Globals.DEBUG or Globals.progress[0] >= len(Globals.bio_questions) and Globals.progress[1] >= len(Globals.phys_questions) and Globals.progress[2] >= len(Globals.cs_questions):
		$Container/VBoxContainer/Menu/MarginContainer/SubjectSelector/MarginContainer/VBoxContainer/VBoxContainer/ShuffleBtn.text = "Daily Shuffle"
	for btn in stage_list.get_children():
		if int(btn.text) <= Globals.progress[Globals.mode] + 1:
			btn.visible = true
		
		if int(btn.text) <= Globals.progress[Globals.mode]:
			btn.theme = completed_theme

func _on_PlayBtn_pressed():
	subject_panel.visible = true
	$click.play()

func _on_SubjectBtn_pressed(subject_id: int):
	lvl_list.clear()
	$click.play()
	for child in stage_list.get_children():
		child.queue_free()
	
	if subject_id == 0:
		Globals.questions = Globals.bio_questions
		subject_lbl.text = "BIOLOGY"
		Globals.mode = 0
	elif subject_id == 1:
		Globals.questions = Globals.phys_questions
		subject_lbl.text = "PHYSICS"
		Globals.mode = 1
	elif subject_id == 2:
		Globals.questions = Globals.cs_questions
		subject_lbl.text = "COMPUTER SCIENCE"
		Globals.mode = 2
	elif subject_id == 3:
		Globals.mode = 3
		if Globals.DEBUG or Globals.progress[0] >= len(Globals.bio_questions) and Globals.progress[1] >= len(Globals.phys_questions) and Globals.progress[2] >= len(Globals.cs_questions):
			Globals.questions = Globals.bio_questions + Globals.phys_questions + Globals.cs_questions
			Globals.questions.shuffle()
			Globals.questions = Globals.questions.slice(0, 9)
			subject_lbl.text = "DAILY SHUFFLE"
		else:
			$Alert.visible = true
			return
	
	for i in range(1, len(Globals.questions) + 1):
		var btn : Button = stage_btn.instance()
		btn.text = str(i)
		
		if i != 1 and Globals.progress[Globals.mode] <= i and not Globals.DEBUG:
			btn.visible = false
		
		print(Globals.questions[i - 1][0].begins_with("start:"))
		
		if Globals.questions[i - 1][0].begins_with("start:"):
			btn.connect("pressed", self, "_on_StageBtn_pressed", [((i) * -1)])
			lvl_list.append(i * -1)
		else:
			btn.connect("pressed", self, "_on_StageBtn_pressed", [(i)])
			lvl_list.append(i)
		stage_list.add_child(btn)
		pass
	
	level_select.visible = true
	print(lvl_list)
	Globals.lvl_list = lvl_list

func _on_BackBtn_pressed():
	$click.play()
	level_select.visible = false

func _on_StageBtn_pressed(stage_id: int):
	if is_instance_valid(cur_level):
		cur_level.queue_free()
		
	$click.play()
	print(str(stage_id))
	var game : PackedScene
	if stage_id >= 0:
		Globals.cur_question = stage_id - 1
		game = preload("res://scenes/WordGuess.tscn")
		cur_level = game.instance()
		cur_level.connect("next_level", self, "_on_StageBtn_pressed")
	else:
		Globals.cur_question = (stage_id * -1) - 1
		game = preload("res://scenes/MultipleChoice.tscn")
		cur_level = game.instance()
		cur_level.connect("next_level", self, "_on_StageBtn_pressed")
	
	add_child(cur_level)

func _on_ExitBtn_pressed():
	$click.play()
	get_tree().quit(0)

func show_congrats_msg():
	$congrats.play()
	if Globals.mode == 3:
		$Results/Panel/VBoxContainer/Guesses.text = "Check back tomorrow for another set of questions."
	else:
		$Results/Panel/VBoxContainer/Guesses.text = "You cleared all stages in this subject!"
	$Results.visible = true

func _on_Ok_pressed():
	$click.play()
	$Results.visible = false


func _on_AlertOk_pressed():
	$click.play()
	$Alert.visible = false
