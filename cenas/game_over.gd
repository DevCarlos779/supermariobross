extends Node2D

@onready var audioGameOver = $AudioGameOver
@onready var ClickBotao = $ClickBotao
@onready var Botao = $TryAgain
@onready var BotaoSair = $Sair

func _ready():
	audioGameOver.play()

func _on_try_again_pressed() -> void:
	Botao.disabled = true
	audioGameOver.stop()
	ClickBotao.play()
	await ClickBotao.finished
	get_tree().change_scene_to_file("res://cenas/start_game.tscn")


func _on_sair_pressed() -> void:
	BotaoSair.disabled = true
	ClickBotao.play()
	await ClickBotao.finished
	get_tree().quit()
