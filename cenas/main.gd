extends Node

@onready var label_vidas = $HBoxContainer/Label2
@onready var label_fase = $HBoxContainer2/Label2

@onready var MorteInimigo = $MorteInimigo

var vidas = Global.vidas
var fase = Global.mapa

var qtd_inimigos_vivos = 7

func _ready():
	label_vidas.text = str(vidas)
	label_fase.text = str(fase)

func perder_vida():
	vidas -= 1
	Global.vidas -= 1
	label_vidas.text = str(vidas)
	
func ganhar_vida():
	vidas += 1
	Global.vidas += 1
	label_vidas.text = str(vidas)

func inimigo_eliminado():
	MorteInimigo.play()
	qtd_inimigos_vivos -= 1
	print(qtd_inimigos_vivos)
	
	if qtd_inimigos_vivos <= 0:
		Global.mapa += 1
		get_tree().call_deferred("change_scene_to_file", "res://cenas/second_level.tscn")
