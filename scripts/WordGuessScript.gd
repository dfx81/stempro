extends Control

var cur_question : int = 0
var user_answer : String = ""
var placeholder : String = ""
var guesses : int = 0

onready var question_text : Label = $"Container/Panel/Question/Container/Question Label"
onready var question_image : TextureRect = $"Container/Panel/Question/Container/Question Image"
onready var answer_text : Label = $"Container/Panel/Answer/Container/Final Answer"
onready var correct : Label = $"Container/Panel/Answer Hint/Container/Correct Panel/Container/Label"
onready var inaccurate : Label = $"Container/Panel/Answer Hint/Container/Inaccurate Panel/Container/Label"
onready var wrong : Label = $"Container/Panel/Answer Hint/Container/Wrong Panel/Container/Label"
onready var guesses_text : Label = $Results/Margin/Panel/Guesses
onready var results : Control = $Results

func _ready():
	cur_question = Globals.cur_question
	if cur_question == 0 and Globals.mode != 3:
		$Tutorial.visible = true
	var question : String = Globals.questions[cur_question][0]
	if question.begins_with("res://"):
		var image : Texture = load(question)
		question_text.visible = false
		question_image.texture = image
		question_image.visible = true
	else:
		question_text.visible = true
		question_image.visible = false
	
	if len(Globals.questions[cur_question]) == 3:
		question_text.visible = true
		
	question_text.text = Globals.questions[cur_question][0]
	if len(Globals.questions[cur_question]) == 3:
		question_text.text = Globals.questions[cur_question][2]
	
	for letter in Globals.questions[cur_question][1]:
		if letter != " ":
			placeholder += "_"
		else:
			placeholder += " "
	
	print(placeholder)
	answer_text.text = placeholder

func check_answer():
	print(user_answer)
	var to_be_check : Array = ["", user_answer.replace(" ", "")]
	
	to_be_check = check_correct(to_be_check[1])
	print(to_be_check[0] + "|" + to_be_check[1])
	var wrongs : int = check_inaccurate(to_be_check[1], to_be_check[0])
	check_wrong(wrongs)
	return

func check_correct(verify : String):
	var correct_letters : int = 0
	var remaining : String = Globals.questions[cur_question][1].replace(" ", "")
	
	for i in range(0, len(user_answer)):
		if user_answer[i] == " ":
			continue
		if user_answer[i] == Globals.questions[cur_question][1][i]:
			correct_letters += 1
			verify.erase(verify.find(Globals.questions[cur_question][1][i]), 1)
			remaining.erase(remaining.find(user_answer[i]), 1)
	
	correct.text = str(correct_letters)
	return [remaining, verify]

func check_inaccurate(verify : String, remaining : String):
	var inaccurate_letters : int = 0
	var sorted : Array = verify.to_ascii()
	sorted.sort()
	var correct_sorted : Array = remaining.to_ascii()
	correct_sorted.sort()
	
	var wrong_letters : int = 0
	
	for letter in sorted:
		if letter in correct_sorted:
			correct_sorted.remove(correct_sorted.find(letter))
			inaccurate_letters += 1
		else:
			wrong_letters += 1
	
	inaccurate.text = str(inaccurate_letters)
	
	return wrong_letters

func check_wrong(remaining : int):
	wrong.text = str(remaining)

func _on_Keyboard_Button_pressed(key):
	$click.play()
	if len(user_answer) < len(placeholder):
		if placeholder[len(user_answer)] == " ":
			user_answer += " "
		user_answer += key
		update_answer_display()
	
func update_answer_display():
	answer_text.text = ""
	
	for i in range(0, len(placeholder)):
		if i < len(user_answer):
			answer_text.text += user_answer[i]
		else:
			answer_text.text += placeholder[i]

func _on_Backspace_Button_pressed():
	$click.play()
	if len(user_answer) >= 1:
		if user_answer[len(user_answer) - 1] == " ":
			user_answer.strip_edges()
		user_answer = user_answer.substr(0, len(user_answer) - 1)
	
	update_answer_display()

func _on_Clear_Button_pressed():
	$click.play()
	user_answer = ""
	update_answer_display()

func _on_Enter_Button_pressed():
	if len(user_answer) < len(placeholder):
		return
	
	guesses += 1
	check_answer()
	
	if answer_text.text == Globals.questions[cur_question][1]:
		$correct.play()
		guesses_text.text = "You took " + str(guesses) + " tries."
		results.visible = true
		if Globals.progress[Globals.mode] <= Globals.cur_question:
			Globals.progress[Globals.mode] = Globals.cur_question + 1
		
		if not Globals.DEBUG:
			Globals.save_score()
	else:
		$wrong.play()
		user_answer = ""
		update_answer_display()

signal next_level

func _on_Restart_pressed():
	$select.play()
	Globals.cur_question += 1
	
	if Globals.cur_question >= len(Globals.lvl_list):
		get_parent().show_congrats_msg()
		queue_free()
	else:
		emit_signal("next_level", Globals.lvl_list[Globals.cur_question])


func _on_Menu_pressed():
	get_parent_control().get_node("click").play()
	if Globals.cur_question + 1 >= len(Globals.lvl_list):
		get_parent().show_congrats_msg()
	queue_free()

func _on_Button_pressed():
	$Tutorial.visible = false
	$select.play()
