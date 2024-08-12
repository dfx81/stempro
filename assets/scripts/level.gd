extends Node2D

func _on_Area2D_body_entered(body, up: bool, right: bool, down: bool, left: bool):
	if body.has_method("update_valid_dir"):
		body.update_valid_dir(up, right, down, left)
