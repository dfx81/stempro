extends Control

var cur_question : int = 0
var choices : Array = []
var correct = null
var guesses : int = 0
var wrong_theme : Theme = preload("res://assets/themes/kenneyUI-red.tres")
onready var question_label : RichTextLabel = $"Container/Panel/Question/Container/Question Label"
onready var choices_cont : GridContainer = $Container/Panel/AnswerButtons/Choices
onready var result_screen : ColorRect = $Results
onready var guesses_label : Label = $Results/Margin/Panel/Guesses
onready var result_label : Label = $Results/Margin/Panel/Label

func _ready():
	cur_question = Globals.cur_question
	var question : String = Globals.questions[cur_question][0]
	question_label.text = question
	
	var choice_buttons = choices_cont.get_children()
	
	for i in range(1, len(Globals.questions[cur_question])):
		choices.append(Globals.questions[cur_question][i])
		choice_buttons[i - 1].visible = true
		
	correct = choices[0]
	
	choices.shuffle()
	
	for i in range(0, len(choices)):
		choice_buttons[i].text = choices[i]
	
	get_parent_control().get_node("Animation").play("HideLoading")
	
func _on_answer_btn_pressed(id: int):
	guesses += 1
	if choices[id] == correct:
		print("CORRECT")
		$correct.play()
		$Animation.play("ShowResults")
		guesses_label.text = "You took " + str(guesses) + " tries."
		
		if Globals.progress[Globals.mode] <= Globals.cur_question:
			Globals.progress[Globals.mode] = Globals.cur_question + 1
		
		if not Globals.DEBUG:
			Globals.save_score()
	else:
		$wrong.play()
		choices_cont.get_child(id).theme = wrong_theme
		choices_cont.get_child(id).disabled = true

signal next_level



func _on_Menu_pressed():
	get_parent_control().get_node("click").play()
	if Globals.cur_question + 1 >= len(Globals.lvl_list):
		get_parent().show_congrats_msg()
	print(Globals.progress)
	get_parent_control().get_node("Animation").play("HideLoading")
	queue_free()


func _on_Restart_pressed():
	Globals.cur_question += 1
	
	
	print(Globals.progress)
	
	if Globals.cur_question >= len(Globals.lvl_list):
		get_parent().show_congrats_msg()
		queue_free()
		get_parent_control().get_node("Animation").play("HideLoading")
	else:
		emit_signal("next_level", Globals.lvl_list[Globals.cur_question])

func _on_Skip_pressed():
	Globals.cur_question += 1
	emit_signal("next_level", Globals.lvl_list[Globals.cur_question])


func _on_Resume_pressed():
	$Animation.play("HideMenu")
	$select.play()


func _on_Pause_pressed():
	$Animation.play("ShowMenu")
	
	if Globals.cur_question + 1 > Globals.progress[Globals.mode]:
		$Menu/Margin/Panel/Skip.disabled = true
	
	$select.play()
