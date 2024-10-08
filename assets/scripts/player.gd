extends KinematicBody2D

export(NodePath) var front_path: NodePath

var end: PackedScene
var front: Node2D
var speed: int = 140
var dir: Vector2 = Vector2(-1, 0)
var buffer: Vector2 = Vector2.ZERO
var valid: Array = [false, false, false, false]
var play: bool = false

func _ready():
	end = load("res://assets/scenes/end.tscn")
	play = true
	front = get_node(front_path)

func _process(delta):
	if not play:
		return
		
	# print(str(valid) + ":" + str(buffer) + ":" + str(dir))
	if Globals.check_win():
		play = false
	
	if (buffer.y < 0 and valid[0]) or (buffer.x > 0 and valid[1]) or (buffer.y > 0 and valid[2]) or (buffer.x < 0 and valid[3]):
		dir = buffer
		buffer = Vector2.ZERO
	
	if dir.x > 0:
		$AnimatedSprite.play("right")
	else:
		$AnimatedSprite.play("left")
	
	front.global_position.x = global_position.x + (dir.x * 30)
	front.global_position.y = global_position.y + (dir.y * 30)

func _physics_process(delta):
	if play:
		move_and_slide(dir * speed, Vector2.UP)

func _input(event):
	if event.is_action_pressed("move_up"):
		buffer = Vector2(0, -1)
	elif event.is_action_pressed("move_down"):
		buffer = Vector2(0, 1)
	elif event.is_action_pressed("move_left"):
		buffer = Vector2(-1, 0)
	elif event.is_action_pressed("move_right"):
		buffer = Vector2(1, 0)
	
func update_input(dir: int):
	if dir == 0:
		buffer = Vector2(0, -1)
	elif dir == 2:
		buffer = Vector2(0, 1)
	elif dir == 3:
		buffer = Vector2(-1, 0)
	elif dir == 1:
		buffer = Vector2(1, 0)

func update_valid_dir(up: bool, right: bool, down: bool, left: bool):
	valid = [up, right, down, left]


func _on_Area2D_body_entered(body):
	if body.is_in_group("cats"):
		Globals.running = false
		get_tree().get_nodes_in_group("game_manager")[0].play_lose_sound()
		Globals.cur_question = Globals.cur_level
		Globals.lives -= 1
		
		if Globals.lives <= 0:
			die()
			Globals.save_score()
			yield(get_tree().create_timer(3, true), "timeout")
			get_tree().change_scene_to(end)
		else:
			die()
		
			yield(get_tree().create_timer(3, true), "timeout")
			get_tree().reload_current_scene()

func die():
	play = false
	$AnimationPlayer.play("die")
	get_tree().paused = true

func _on_BombArea_body_entered(body):
	pass # Replace with function body.


func _on_BombArea_body_exited(body):
	pass # Replace with function body.
