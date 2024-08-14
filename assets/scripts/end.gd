extends Control

var menu: PackedScene

func _ready():
	menu = preload("res://assets/scenes/menu.tscn")
	$ColorRect/Score.text = "SCORE: " + str(Globals.score).pad_zeros(7)
	
	if Globals.bested:
		$ColorRect/Best.modulate.a = 255

func _input(event):
	if event is InputEventMouseButton:
		var evt: InputEventMouseButton = event
		
		if evt.pressed and $AnimationPlayer.current_animation == "summary":
			$AnimationPlayer.stop(false)
			$AnimationPlayer.play("RESET")
		elif evt.pressed:
			$click.play()
			yield($click, "finished")
			Globals.reset_game()
			get_tree().change_scene_to(menu)
