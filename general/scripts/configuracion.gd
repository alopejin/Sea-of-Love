extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Menu_configuracion.visible = false
	$Menu_dificultad.visible = false
	$Creditos.visible = false

func esconder_boton_configuracion():
	$Boton_configuracion.disabled = true
	$Boton_configuracion.visible = false

func mostrar_boton_configuracion():
	$Boton_configuracion.disabled = false
	$Boton_configuracion.visible = true

func abrir_configuracion():
	get_parent().alternar_botones()
	get_parent().puede_salir = false
	$Boton_configuracion.disabled = true
	if !$Menu_configuracion.visible:
		$Sonido_menu.play()
	alternar_menu()

func cerrar_configuracion():
	get_parent().alternar_botones()
	get_parent().puede_salir = true
	$Boton_configuracion.disabled = false
	$Sonido_click.play()
	alternar_menu()

func abrir_dificultad():
	$Sonido_click.play()
	alternar_menu()
	alternar_dificultad()

func cerrar_dificultad():
	$Sonido_click.play()
	alternar_dificultad()
	alternar_menu()

func dificultad_dificil():
	Global.dificultad_facil = false
	Global.dificultad_dificil = true
	Global.llaves_conseguidas = 0
	Global.juego_cartas_ganado = false
	Global.juego_saltar_ganado = false
	Global.juego_zombies_ganado = false
	Global.record_cartas = 0
	Global.record_saltar = 0
	Global.record_zombies = [0, 0]
	cerrar_dificultad()
	
func dificultad_facil():
	Global.dificultad_facil = true
	Global.dificultad_dificil = false
	Global.llaves_conseguidas = 0
	Global.juego_cartas_ganado = false
	Global.juego_saltar_ganado = false
	Global.juego_zombies_ganado = false
	Global.record_cartas = 0
	Global.record_saltar = 0
	Global.record_zombies = [0, 0]
	cerrar_dificultad()

func abrir_ajustes() -> void:
	$Sonido_click.play()
	$Ajustes.ajustes_abiertos = true
	alternar_menu()
	$Ajustes.alternar_ajustes_globales()

func abrir_creditos() -> void:
	$Sonido_click.play()
	alternar_menu()
	alternar_creditos()

func cerrar_creditos() -> void:
	$Sonido_click.play()
	alternar_creditos()
	alternar_menu()

func alternar_menu() -> void:
	$Menu_configuracion.visible = !$Menu_configuracion.visible

func alternar_dificultad():
	if Global.dificultad_dificil:
		$Menu_dificultad/Boton_300IQ.texture_normal = preload("res://general/assets/boton_base2_dificil.png")
		$Menu_dificultad/Boton_300IQ.texture_hover = null
	else:
		$Menu_dificultad/Boton_300IQ.texture_normal = preload("res://general/assets/boton_base2.png")
		$Menu_dificultad/Boton_300IQ.texture_hover = preload("res://general/assets/boton_base2_hover.png")
	
	if Global.dificultad_facil:
		$Menu_dificultad/Boton_noob.texture_normal = preload("res://general/assets/boton_base2_facil.png")
		$Menu_dificultad/Boton_noob.texture_hover = null
	else:
		$Menu_dificultad/Boton_noob.texture_normal = preload("res://general/assets/boton_base2.png")
		$Menu_dificultad/Boton_noob.texture_hover = preload("res://general/assets/boton_base2_hover.png")
	
	$Menu_dificultad.visible = !$Menu_dificultad.visible

func alternar_creditos():
	$Creditos.visible = !$Creditos.visible
