extends Node


const POSICION_INICIAL_MAR := Vector2i(163.0, 417.0)
const POSICION_INICIAL_CAMARA := Vector2i(0, 0)
const VELOCIDAD_INICIAL : float = 2.0
const VELOCIDAD_MAX : int = 5
const ACELERACION : int = 6000
const VELOCIDAD_CIGARRO = -2000

var velocidad : float
var tamaño_pantalla : Vector2i
var juego_activo: bool
var movimiento: int
var puntuacion_jugador : int
var record: int

var altura_suelo := 182
var porro = preload("res://juego2/escenas/porro.tscn")
var reloj = preload("res://juego2/escenas/reloj2.tscn")
var cigarro = preload("res://juego2/escenas/cigarro_2.tscn")
var obstaculos_terrestres := [porro, reloj]
var obstaculos_terrestres_creados
var ultimo_obstaculo_terrestre
var cigarros_creados
var ultimo_cigarro
var puede_crear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.intro = false
	desactivar_botones()
	await get_tree()
	tamaño_pantalla = get_viewport().get_visible_rect().size
	nuevo_juego()

func nuevo_juego():
	$Pausa.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	$Salir_o_empezar/Musica.play()
	
	juego_activo = false
	movimiento = 0
	puntuacion_jugador = 0
	obstaculos_terrestres_creados = []
	ultimo_obstaculo_terrestre = null  
	cigarros_creados = []
	ultimo_cigarro = null
	velocidad = VELOCIDAD_INICIAL
	tamaño_pantalla = get_viewport().get_visible_rect().size
	
	for c in get_children():
		if c in obstaculos_terrestres_creados:
			c.queue_free()
	
	process_mode = Node.PROCESS_MODE_INHERIT
	$mar_runner.position = POSICION_INICIAL_MAR
	$camara.position = POSICION_INICIAL_CAMARA
	$mar_runner.velocity = Vector2i(0, 0)
	$suelo_runner.position = Vector2i(0, 0)
	$Pausa/info_runner/Label_puntuacion.visible = false
	$Pausa/info_runner/Label_record.visible = false
	$Pausa/Label_empezar.visible = true
	$mar_runner/mar_animacion.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(juego_activo):
		generar_obstaculos()
		
		if puntuacion_jugador/100 > 100:
			generar_cigarros()
		
		velocidad = VELOCIDAD_INICIAL + movimiento / ACELERACION 
		puntuacion_jugador += velocidad - 1
		
		if velocidad > VELOCIDAD_MAX:
			velocidad = VELOCIDAD_MAX
		$mar_runner.position.x += velocidad
		$camara.position.x += velocidad
		movimiento += velocidad
		mostrar_puntuacion()
		
		if $camara.position.x - $suelo_runner.position.x > tamaño_pantalla.x:
			$suelo_runner.position.x += tamaño_pantalla.x
	else:
		if Input.is_action_pressed("empezar"):
			await get_tree().create_timer(0.1).timeout
			juego_activo = true
			$Pausa/Label_empezar.visible = false
			$Pausa/info_runner/Label_puntuacion.visible = true
			$Pausa/info_runner/Label_record.visible = true
			$mar_runner/mar_animacion.play()

func generar_obstaculos():
	tamaño_pantalla = get_viewport().get_visible_rect().size
	if obstaculos_terrestres_creados.is_empty() or ultimo_obstaculo_terrestre.position.x < movimiento + randi_range(200, 400):
		var tipo_obstaculo_terrestre = obstaculos_terrestres[randi() % obstaculos_terrestres.size()]
		var aux
		var posicion_x_aux
		var posicion_y_aux
		
		aux = tipo_obstaculo_terrestre.instantiate()
		posicion_x_aux = tamaño_pantalla.x + movimiento + 100
		posicion_y_aux = tamaño_pantalla.y - altura_suelo - 40
		aux.position = Vector2(posicion_x_aux, posicion_y_aux)
		aux.body_entered.connect(comprobar_colision)
		ultimo_obstaculo_terrestre = aux
		add_child(aux)
		obstaculos_terrestres_creados.append(aux)

func generar_cigarros():
	tamaño_pantalla = get_viewport().get_visible_rect().size
	if (cigarros_creados.is_empty() or ultimo_cigarro.position.x < movimiento + randi_range(-1000, -100)):
		puede_crear = false
		$Timer_cigarro.start()
		var aux
		var posicion_x_aux
		var posicion_y_aux
		
		aux = cigarro.instantiate()
		posicion_x_aux = tamaño_pantalla.x + movimiento + 100
		var r = randf() > 0.5
		
		if r:
			posicion_y_aux = tamaño_pantalla.y - altura_suelo - 120
		else:
			posicion_y_aux = tamaño_pantalla.y - altura_suelo - 250
			
		aux.position = Vector2(posicion_x_aux, posicion_y_aux)
		aux.get_node("Area2D").body_entered.connect(comprobar_colision)
		ultimo_cigarro = aux
		add_child(aux)
		cigarros_creados.append(aux)

func timer_cigarro():
	puede_crear = true

func mostrar_puntuacion():
	$Pausa/info_runner/Label_puntuacion.text = "Puntuacion :  " + str(puntuacion_jugador / 100)
	$Pausa/info_runner/Label_record.text = "Record :  " + str(Global.record_saltar)

func comprobar_colision(jugador: CharacterBody2D):
	if jugador.name == "mar_runner":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Salir_o_empezar/Sonido_hostia.play()
		$Pausa.set_process_mode(Node.PROCESS_MODE_DISABLED)
		comprobar_desbloqueo()
		
		record = puntuacion_jugador / 100
		
		if(record > Global.record_saltar):
			Global.record_saltar = record
		
		activar_botones()
		get_tree().paused = true

func comprobar_desbloqueo():
	if puntuacion_jugador > 10000 and Global.dificultad_facil:
		$Salir_o_empezar/Botones/Llave_desbloqueada.desbloqueo_saltar();
		
	if puntuacion_jugador > 20000 and Global.dificultad_dificil:
		$Salir_o_empezar/Botones/Llave_desbloqueada.desbloqueo_saltar();

func activar_botones():
	$Pausa/info_runner/Label_derrota.visible = true
	$Salir_o_empezar/Botones/Boton_reiniciar.disabled = false
	$Salir_o_empezar/Botones/Boton_reiniciar.visible = true
	$Salir_o_empezar/Botones/Boton_salir.disabled = false
	$Salir_o_empezar/Botones/Boton_salir.visible = true

func desactivar_botones():
	$Pausa/info_runner/Label_derrota .visible = false
	$Salir_o_empezar/Botones/Boton_reiniciar.disabled = true
	$Salir_o_empezar/Botones/Boton_reiniciar.visible = false
	$Salir_o_empezar/Botones/Boton_salir.disabled = true
	$Salir_o_empezar/Botones/Boton_salir.visible = false

func salir() -> void:
	$Pausa/Sonido_click.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu_principal/escenas/menu_principal.tscn")

func reiniciar() -> void:
	$Pausa/Sonido_click.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
