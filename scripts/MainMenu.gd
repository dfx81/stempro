extends Control

onready var subject_panel : Panel = $Container/VBoxContainer/Menu/MarginContainer/SubjectSelector
onready var level_select : Panel = $Container/VBoxContainer/Menu/MarginContainer/LevelSelector
onready var subject_lbl : Label = $Container/VBoxContainer/Menu/MarginContainer/LevelSelector/MarginContainer/VBoxContainer/Category
onready var stage_list : GridContainer = $Container/VBoxContainer/Menu/MarginContainer/LevelSelector/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/StageList
onready var stage_btn : PackedScene = preload("res://scenes/StageBtn.tscn")

var lvl_list : Array = []
var cur_level = null

func _ready():
	#Globals.bio_questions.shuffle()
	#Globals.phys_questions.shuffle()
	#Globals.cs_questions.shuffle()
	pass

func _process(_delta):
	refresh()

func refresh():
	for btn in stage_list.get_children():
		if int(btn.text) <= Globals.progress[Globals.mode] + 1:
			btn.visible = true

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
	
	for i in range(1, len(Globals.questions) + 1):
		var btn : Button = stage_btn.instance()
		btn.text = str(i)
		
		if i != 1 and Globals.progress[Globals.mode] <= i:
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
