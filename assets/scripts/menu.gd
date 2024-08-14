extends Control

var start: bool
var game: PackedScene

func _ready():
	game = load("res://assets/scenes/game.tscn")
	Globals.load_score()
	$ColorRect/Best.text = "HI-SCORE: " + str(Globals.best).pad_zeros(7)
	start = false

func _on_Transition_gui_input(event: InputEvent):
	if start:
		return
		
	if event is InputEventMouseButton:
		var evt: InputEventMouseButton = event
		
		if evt.pressed and $AnimationPlayer.current_animation == "fade_in":
			$AnimationPlayer.stop(false)
			$AnimationPlayer.play("idle")
		elif evt.pressed:
			$AnimationPlayer.play("fade_out")
			$click.play()
			yield($AnimationPlayer, "animation_finished")
			get_tree().change_scene_to(game)
