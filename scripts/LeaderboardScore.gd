extends HBoxContainer

func set_values(rank, user, score, signature, user_signature):
	$Rank.text = str(rank)
	$User.text = str(user)
	$Score.text = str(score)
	
	if signature == user_signature:
		$Rank.add_color_override("font_color", Color.darkgreen)
		$User.add_color_override("font_color", Color.darkgreen)
		$Score.add_color_override("font_color", Color.darkgreen)
