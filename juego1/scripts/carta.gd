extends TextureButton


var id_carta = 0
var volteada = false
var coincide = false

var texturas_cartas = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$animacion_cartas.visible = false
	texturas_cartas = [
	preload("res://juego1/assets/carta1.png"),
	preload("res://juego1/assets/carta2.png"),
	preload("res://juego1/assets/carta3.png"),
	preload("res://juego1/assets/carta4.png"),
	preload("res://juego1/assets/carta5.png"),
	preload("res://juego1/assets/carta6.png")
	]
	texture_normal = preload("res://juego1/assets/carta_sin_voltear2.png")
	texture_pressed = preload("res://juego1/assets/carta_sin_voltear_pulsada2.png")
	texture_hover = preload("res://juego1/assets/cartahover.png")

func voltear():
	if !get_parent().get_parent().juego_activo and Global.dificultad_dificil:
		get_parent().get_parent().juego_activo = true
		get_parent().get_parent().get_node("Timer").start()
	
	if volteada or coincide:
		return
	volteada = true
	texture_normal = null
	texture_pressed = null
	texture_hover = null
	$animacion_cartas.visible = true
	$animacion_cartas.play("volteo")
	await $animacion_cartas.animation_finished
	$animacion_cartas.visible = false
	texture_normal = texturas_cartas[id_carta - 1]

func esconder():
		volteada = false
		coincide = false
		texture_normal = preload("res://juego1/assets/carta_sin_voltear2.png")
		texture_pressed = preload("res://juego1/assets/carta_sin_voltear_pulsada2.png")
		texture_hover = preload("res://juego1/assets/cartahover.png")
