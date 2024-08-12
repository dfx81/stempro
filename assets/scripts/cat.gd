extends KinematicBody2D

export(Array, NodePath) var target_path: Array
export(NodePath) var spawn_path: NodePath
export(NodePath) var home_path: NodePath
export(int) var speed: int = 150
export(bool) var spawning: bool = true
export(float) var spawn_delay: float = 5
export(float) var chase_time: float = 10

var cur_target: int = 0
var target: Node2D
var spawn_point: Node2D
var home_point: Node2D
var agent: NavigationAgent2D
var dir: Vector2 = Vector2.ZERO
var chasing: bool = false
var chase_timer: float
var random: bool = false
var max_speed: int
var speed_timer: float = 0

signal spawned

func _ready():
	add_to_group("cats")
	agent = $NavigationAgent2D
	if len(target_path) > 0:
		target_path.shuffle()
		target = get_node(target_path[cur_target])
	else:
		target_path = get_tree().get_nodes_in_group("path")
		target_path.shuffle()
		target = target_path[cur_target]
		random = true
	spawn_point = get_node(spawn_path)
	home_point = get_node(home_path)
	chase_timer = chase_time
	max_speed = speed + Globals.diff
	speed = speed + Globals.diff / Globals.max_diff * 20
	
func _process(delta):
	speed_timer += delta
	
	if speed_timer >= 10:
		speed_timer -= 10
		speed += 1
		
		if speed > max_speed:
			speed = max_speed
	
	if chasing:
		chase_timer += delta
	
	if chase_timer >= chase_time and chase_time > 0:
		print("retreating")
		chasing = false
		chase_timer -= chase_time
	
	if spawning:
		spawn_delay -= delta
		
		if spawn_delay <= 0:
			spawn()
			yield(self, "spawned")
			spawning = false
	
	if dir.x > 0:
		$AnimatedSprite.play("right")
	else:
		$AnimatedSprite.play("left")

func _physics_process(delta):
	if spawning or target == null:
		return
	
	if agent.is_navigation_finished() and not chasing:
		print("chasing")
		if not random:
			retarget()
		chasing = true
	elif agent.is_navigation_finished() and chasing:
		print("retreating")
		chasing = false
		chase_timer -= chase_time
		cur_target += 1
		
		if (cur_target >= len(target_path)):
			cur_target = 0
		
		if random:
			target = target_path[cur_target]
		else:
			retarget()
	
	if target.is_in_group("removed"):
		retarget()
		
	if chasing and target != null:
		agent.set_target_location(target.global_position)
		$Sprite.global_position = target.global_position
	else:
		agent.set_target_location(home_point.global_position)
		$Sprite.global_position = home_point.global_position
	
	var next: Vector2 = agent.get_next_location()
	dir = global_position.direction_to(next)
	
	move_and_slide(dir * speed)

func spawn():
	var tween: SceneTreeTween = get_tree().create_tween()
	yield(tween.tween_property(self, "global_position", spawn_point.global_position, 1), "finished")
	emit_signal("spawned")

func retarget():
	target = null
	
	if Globals.answer_pos >= len(Globals.answer):
		return
	
	while target == null:
		target = get_node_or_null(target_path[cur_target])
		
		if target.visible == false or target.get_child_count() == 0:
			target = null
			cur_target = cur_target + 1 if cur_target + 1 < len(target_path) else 0
