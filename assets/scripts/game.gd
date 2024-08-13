extends Node2D

var question: Array
var spots: Array
var letter_scene: PackedScene
var hint: String = ""
var win: bool = false
var last_ans_pos: int

func _ready():
	randomize()
	last_ans_pos = Globals.answer_pos
	question = Globals.get_question()
	update_hint()
	$CanvasLayer/ColorRect/Stage.bbcode_text = "[center]STAGE " + str(Globals.stage) + "[/center]"
	$CanvasLayer/ColorRect/Question.bbcode_text = "[center]" + question[0] + "[/center]"
	$CanvasLayer/ColorRect/Lives.bbcode_text = "[right]LIVES X" + str(Globals.lives) + "[/right]"
	$CanvasLayer/ColorRect/Answer.bbcode_text = "[center][wave amp=50 freq=10]" + Globals.answer + "[/wave][/center]"
	get_tree().paused = true
	letter_scene = preload("res://assets/scenes/letter.tscn")
	
	spots = get_tree().get_nodes_in_group("letter_spot")
	spots.shuffle()
	
	if not Globals.persist:
		for i in range(Globals.answer_pos, len(Globals.answer)):
			if Globals.answer[i] == ' ':
				continue
			
			var letter: Node2D = letter_scene.instance()
			letter.load_letter(Globals.answer[i])
			
			var spot: Node2D = spots[0]
			spot.add_child(letter)
			Globals.persist.append(spot.get_index())
			spots.remove(0)
	else:
		for i in range(Globals.answer_pos, len(Globals.persist)):
			if Globals.answer[i] == ' ':
				continue
			
			var letter: Node2D = letter_scene.instance()
			letter.load_letter(Globals.answer[i])
			
			var spot: Node2D = $CanvasLayer/ViewportContainer/Viewport/Node2D/level/letters.get_child(Globals.persist[i])
			spot.add_child(letter)
	start()

func start():
	yield(get_tree().create_timer(3, true), "timeout")
	get_tree().paused = false
	$Chasing.play()
	Globals.running = true

func _process(delta):
	if Input.is_action_just_released("ui_cancel") and Globals.running:
		get_tree().paused = not get_tree().paused
	
	$CanvasLayer/ColorRect/Score.bbcode_text = str(Globals.score).pad_zeros(7)
	win = Globals.check_win()
	
	if last_ans_pos < Globals.answer_pos and not win:
		last_ans_pos = Globals.answer_pos
		update_hint()
	
	if win:
		if Globals.running:
			$Win.play()
		Globals.running = false
		Globals.stage += 1
		Globals.persist = []
		$CanvasLayer/ColorRect/Answer.visible = true
		$CanvasLayer/ColorRect/Hint.visible = false
		Globals.score += int(Globals.time)
		$CanvasLayer/ColorRect/Score.bbcode_text = str(Globals.score).pad_zeros(7)
		get_tree().paused = true
		Globals.answer_pos = 0
		yield(get_tree().create_timer(3, true), "timeout")
		Globals.diff_up()
		Globals.time = Globals.time_default
		
		var reset_list: Array = get_tree().get_nodes_in_group("removed")
		
		for item in reset_list:
			item.visible = true
			item.remove_from_group("removed")
		
		get_tree().reload_current_scene()
	else:
		if not get_tree().paused:
			Globals.time -= delta
			print(Globals.time)

func update_hint():
	hint = ""
	var intensity = (Globals.answer_pos) / len(Globals.answer) * 10 + 10
	
	for i in range(0, Globals.answer_pos):
		hint += Globals.answer[i]
	
	for i in range(Globals.answer_pos, len(Globals.answer)):
		hint += "_" if Globals.answer[i] != ' ' else ' '
	
	$CanvasLayer/ColorRect/Hint.bbcode_text = "[center][shake rate=" + str(intensity + 10) + " level=" + str(intensity + 10) + " connected=0]" + hint + "[/shake][/center]"

func _on_input_pressed(dir: int):
	$CanvasLayer/ViewportContainer/Viewport/Node2D/level/player.update_input(dir)

func play_collect_sound():
	$Chasing.stop()
	$Collect.play(0.1)
	yield($Collect, "finished")
	$Chasing.play()

func play_lose_sound():
	$Chasing.stop()
	$Lose.play()

func play_win_sound():
	$Chasing.stop()
	$Win.play()
