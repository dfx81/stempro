extends Control

var cur_question : int = 0
var user_answer : String = ""
var placeholder : String = ""
var guesses : int = 0

onready var question_text : Label = $"Container/Panel/Question/Container/Question Label"
onready var question_image : TextureRect = $"Container/Panel/Question/Container/Question Image"
onready var answer_text : Label = $"Container/Panel/Answer/Container/Final Answer"
onready var guesses_text : Label = $Results/Margin/Panel/Guesses
onready var results : Control = $Results
onready var score_label : Label = $Container/Panel/Score
onready var keys : Array = $"Container/Panel/Keyboard/Container/Keyboard Row 1".get_children() + $"Container/Panel/Keyboard/Container/Keyboard Row 2".get_children() + $"Container/Panel/Keyboard/Container/Keyboard Row 3".get_children()

var base_theme : Theme = preload("res://assets/themes/kenneyUI.tres")
var wrong_theme : Theme = preload("res://assets/themes/kenneyUI-red.tres")
var correct_theme : Theme = preload("res://assets/themes/kenneyUI-green.tres")
var score : float = 300
var started : bool = false
var can_submit : bool = false

func _process(delta):
	if not $Timer.paused:
		score = $Timer.time_left - (guesses * 10)
		score_label.text = "SCORE: " + str(int(score)) + " pts"

func _ready():
	placeholder = ""
	for btn in keys:
		btn.disabled = false
		btn.theme = base_theme
	
	cur_question = Globals.cur_question
	if Globals.tutorial_viewed == 0:
		$Tutorial.visible = true
	else:
		started = true
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
	
	print(cur_question)
	
	for letter in Globals.questions[cur_question][1]:
		if letter != " ":
			placeholder += "_"
		else:
			placeholder += " "
	
	print(placeholder)
	answer_text.text = placeholder
	
	get_parent_control().get_node("Animation").play("HideLoading")

func _on_Keyboard_Button_pressed(key):
	$click.play()
	if key in Globals.questions[cur_question][1]:
		var target: Node = find_node(key + " Button")
		target.theme = correct_theme
		target.disabled = true
		
		for i in range(0, len(Globals.questions[cur_question][1])):
			if Globals.questions[cur_question][1][i] == key:
				answer_text.text[i] = key
		
		if not "_" in answer_text.text:
			$correct.play()
			started = false
			$HTTPRequest.connect("request_completed", self, "_on_request_completed")
			$HTTPRequest.request("https://app-data.fly.dev/api/v2/scores/com.kmk.stempro?limit=5")
			yield($HTTPRequest, "request_completed")
			
			guesses_text.text = "SCORE: " + str(int(score)) + " pts"
			
			if can_submit:
				guesses_text.text = guesses_text.text + " (NEW)"
			
			if Globals.cur_question < 4:
				Globals.cur_question += 1
				_ready()
			else:
				$Animation.play("ShowResults")
	else:
		var target: Node = find_node(key + " Button")
		target.theme = wrong_theme
		target.disabled = true
		guesses += 1
		score -= 10

signal reload_level

func _on_Restart_pressed():
	Globals.generate_shuffle_mode_lvl_list()
	Globals.cur_question = 0
	emit_signal("reload_level")

signal refresh_score

func _on_request_completed(result, res_code, headers, body):
	if res_code == 200:
		var data = JSON.parse(body.get_string_from_utf8())
		var better_personal_best: bool = false
		var has_dupe: bool = false
		
		if data.result["scores"]:
			can_submit = false
			
			for lb_score in data.result["scores"]:
				if Globals.SIGNATURE == lb_score[3] and score > lb_score[1]:
					can_submit = true
					better_personal_best = true
					break
				elif Globals.SIGNATURE == lb_score[3] and score < lb_score[1]:
					has_dupe = true
					break
				elif score > lb_score[1]:
					can_submit = true
					break
			
			if can_submit:
				$Submit.connect("request_completed", self, "_get_signature")
				$Submit.request(
					"https://app-data.fly.dev/api/v2/scores/com.kmk.stempro",
					[
						"Authorization: Basic " + Marshalls.utf8_to_base64(Globals.USERNAME + ":" + Globals.PASSKEY),
						"Content-Type: application/json"
					],
					true,
					HTTPClient.METHOD_POST,
					JSON.print({"score": score})
				)
				yield($Submit, "request_completed")
				emit_signal("refresh_score")

func _on_Menu_pressed():
	get_parent_control().get_node("click").play()
	get_parent_control().get_node("Animation").play("ShowLoading")
	yield(get_parent_control().get_node("Animation"), "animation_finished")
	
	print(Globals.progress)
	queue_free()
	get_parent_control().get_node("Animation").play("HideLoading")

func _on_Button_pressed():
	$Tutorial.visible = false
	$select.play()
	Globals.tutorial_viewed = 1
	Globals.save_score()
	started = true

func _on_Help_pressed():
	$Tutorial.visible = true
	$select.play()


func _on_Resume_pressed():
	$Animation.play("HideMenu")
	$Timer.paused = false
	$select.play()
	started = true

func _on_Pause_pressed():
	started = false
	$Timer.paused = true
	$Animation.play("ShowMenu")
	
	if Globals.cur_question + 1 > Globals.progress[Globals.mode]:
		$Menu/Margin/Panel/Skip.disabled = true
	
	$select.play()
