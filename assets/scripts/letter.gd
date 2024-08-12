extends Sprite

var letter: String

func load_letter(chr: String):
	var texture_path: String = "res://assets/sprites/tile_" + chr.to_lower() + ".png"
	var texture_instance: Texture = load(texture_path)
	letter = chr
	texture = texture_instance

func _ready():
	$AnimationPlayer.play("idle")


func _on_Area2D_body_entered(body: KinematicBody2D):
	if body.is_in_group("player"):
		var correct: bool = Globals.check_letter(letter)
		print(letter.to_upper() + " found (" + str(correct) + ")")
		
		if correct:
			Globals.score += 10
			get_parent().visible = false
			get_parent().add_to_group("removed")
