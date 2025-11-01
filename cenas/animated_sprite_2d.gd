extends AnimatedSprite2D

class_name PlayerAnimatedSprite

func trigger_animation(velocity: Vector2, direction: int, player_mode: Player.PlayerMode):
	var animation_prefix = Player.PlayerMode.keys()[player_mode].to_snake_case()
	
	if not get_parent().is_on_floor():
		play("%s_jump" % animation_prefix)
	
	elif sign(velocity.x) != sign(direction) && velocity.x != 0 && direction != 0:
		play("%s_slide" % animation_prefix)
		scale.x = abs(scale.x) * direction  # ✅ Corrigido
	
	else:
		if velocity.x != 0:
			scale.x = abs(scale.x) * sign(velocity.x)  # ✅ Corrigido
			play("%s_run" % animation_prefix)
		else:
			play("%s_idle" % animation_prefix)
