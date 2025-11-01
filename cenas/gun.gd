extends Area2D

class_name Gun

@export var speed = 200.0  # pixels por segundo
@onready var ray_cast_2d_left = $RayCast2DLeft as RayCast2D
@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var ray_cast_2d_right = $RayCast2DRight as RayCast2D

var direction := 1  # 1 = direita, -1 = esquerda

func _ready():
	sprite_2d.flip_h = direction == -1

func _process(delta):
	position.x += speed * direction * delta
	
	if ray_cast_2d_left.is_colliding():
		queue_free()
	
	if ray_cast_2d_right.is_colliding():
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)

func handle_enemy_collision(enemy: Enemy):
	enemy.die_from_hit()
