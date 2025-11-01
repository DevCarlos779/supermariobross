extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode {
	SMALL,
	BIG,
	SHOOTING
}

signal points_scored(points: int)

const POINTS_LABEL_SCENE = preload("res://cenas/points_label.tscn")

@export var gun = preload("res://cenas/gun.tscn")

@onready var ptoShootRight = $ptoShootRight
@onready var ptoShootLeft = $ptoShootLeft

@onready var TomarDano = $TomandoDano
@onready var Transformacao = $Transformacao
@onready var GanhandoVida = $GanhandoVida
@onready var Tiro = $Tiro
@onready var Passos = $Passos
@onready var Pulo = $Pulo

@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_collision_shape_2d = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d = $BodyCollisionShape2D
#@enready var area_2d = $Area2D

@export_group("Locomotion")
#aumenei para que o mario nao demorasse tanto para parar de correr
#e começar a correr em velocidade maxima
@export var run_speed_damping = 2
@export var speed = 100.0
@export var jump_velocity = -450
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150
@export_group("")

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_mode
var is_dead = false
var is_shooting = false
var is_tranforming = false
var is_intangivel = false

func _physics_process(delta: float) -> void:
	
	if Global.estadoAtualMario == "small":
		player_mode = PlayerMode.SMALL
		
	else:
		player_mode = PlayerMode.SHOOTING
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_tranforming:
		Pulo.play()
		Passos.stop()
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("jump") and velocity.y < 0 and not is_tranforming:
		Pulo.play()
		Passos.stop()
		velocity.y *= 0.75
	
	var direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("shoot") and player_mode == PlayerMode.SHOOTING:
		is_shooting = true
		animated_sprite_2d.play("shooting")
		await animated_sprite_2d.animation_finished
		Tiro.play()
		print("atirou")
		var g = gun.instantiate()
		
		if direction == 1:
			g.global_position = ptoShootRight.global_position
		else:
			g.global_position = ptoShootLeft.global_position
			
		g.direction = sign(animated_sprite_2d.scale.x) # vai pra direção do Mario
		get_parent().add_child(g)
		is_shooting = false
	
	if direction and not is_tranforming:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		Passos.play()
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		
	if not is_shooting and not is_tranforming:
		animated_sprite_2d.trigger_animation(velocity, direction, player_mode)
	
	
	
	move_and_slide()
	

func spawn_points_label(enemy):
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child((points_label))
	points_scored.emit(100)

func die():
	if get_parent().vidas <= 1 and is_tranforming == false and is_intangivel == false:
		TomarDano.play()
		Passos.stop()
		Global.mapa = 1
		Global.vidas = 1
		Global.estadoAtualMario = "small"
		is_dead = true
		animated_sprite_2d.play("small_death")
		set_physics_process(false)
		
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
		await death_tween.finished
		
		get_tree().call_deferred("change_scene_to_file", "res://cenas/game_over.tscn")
	
	
	elif player_mode == PlayerMode.SHOOTING and is_tranforming == false and is_intangivel == false:
		TomarDano.play()
		is_intangivel = true
		is_tranforming = true
		Global.estadoAtualMario = "small"
		get_parent().perder_vida()
		
		animated_sprite_2d.play("shooting_to_small")
		await animated_sprite_2d.animation_finished
		player_mode = PlayerMode.SMALL
		
		#var collision_shape_mario_shooting = area_collision_shape_2d.shape as RectangleShape2D
		#collision_shape_mario_shooting.size = Vector2(13, 16)
	
		#var body_collision_shape_mario_shooting = body_collision_shape_2d.shape as RectangleShape2D
		#body_collision_shape_mario_shooting.size = Vector2(13, 16)
		
		is_tranforming = false
		await get_tree().create_timer(3.0).timeout
		
		is_intangivel = false
	
	elif player_mode == PlayerMode.SMALL and is_tranforming == false and is_intangivel == false:
		TomarDano.play()
		is_intangivel = true
		is_tranforming = true
		get_parent().perder_vida()
		TomarDano.play()
		animated_sprite_2d.play("loosing_life")
		await animated_sprite_2d.animation_finished
		is_tranforming = false
		
		await get_tree().create_timer(3.0).timeout
		
		is_intangivel = false
	
