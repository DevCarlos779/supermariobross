extends Node2D

@onready var audioCongratulations = $AudioCongratulations
@onready var ClickBotao = $ClickBotao
@onready var Botao = $GoToHome

func _ready():
	audioCongratulations.play()

func _on_go_to_home_pressed() -> void:
	Botao.disabled = true
	audioCongratulations.stop()
	ClickBotao.play()
	await ClickBotao.finished
	get_tree().change_scene_to_file("res://cenas/start_game.tscn")
