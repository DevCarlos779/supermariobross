extends Node2D

@onready var audioInicial = $AudioTelaInicial
@onready var ClickBotao = $ClickBotao
@onready var Botao = $Play
@onready var BotaoSair = $Sair

func _ready():
	audioInicial.play()

func _on_play_pressed() -> void:
	Botao.disabled = true
	audioInicial.stop()
	ClickBotao.play()
	await ClickBotao.finished
	get_tree().change_scene_to_file("res://cenas/main.tscn")


func _on_sair_pressed() -> void:
	BotaoSair.disabled = true
	ClickBotao.play()
	await ClickBotao.finished
	get_tree().quit()
