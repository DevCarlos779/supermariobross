extends Area2D

class_name Enemy

@onready var ray_cast_2d_down = $RayCast2DDown as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

func _process(delta):
	 
	if !ray_cast_2d_down.is_colliding():
		position.y += 100 * delta
	
	animated_sprite_2d.flip_h = true

func die_from_hit():
	animated_sprite_2d.play("dead")
	get_parent().get_parent().inimigo_eliminado()
	get_tree().create_timer(0.5).timeout.connect(queue_free)
	
