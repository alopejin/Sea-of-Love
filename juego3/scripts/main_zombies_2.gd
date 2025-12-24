extends Node


@onready var jugador: CharacterBody2D = $mar_zombies
@onready var zombies = preload("res://juego3/escenas/zombie_3.tscn")

var tipos_zombie

var zombies_creados : int
var zombies_izquierda : int
var zombies_derecha :int
var zombies_totales : int
var zombies_vivos : int
var zombies_eliminados : int
var puede_comprar : bool = false
var headshots : int
var ronda : int
var dinero : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.intro = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_custom_mouse_cursor(preload("res://juego3/assets/cruceta4-ajustada.png"), Input.CURSOR_ARROW, Vector2(16, 16))
	ocultar_marcadores()
	$Pausa.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	jugador.global_position = Vector2i(600, -400)
	jugador.get_node("mar_animacion").play("vestido_verde")
	$Label_siguiente_ronda.visible = false
	$Label_derrota.visible = false
	$Salir_o_empezar/Musica1.play()
	desactivar_botones()
	
	zombies_eliminados = 0
	headshots = 0
	ronda = 1
	dinero = 0
	zombies_izquierda = randi_range(2, 3)
	zombies_derecha = randi_range(2, 3)
	zombies_totales = zombies_izquierda + zombies_derecha
	zombies_vivos = zombies_totales
	
	await get_tree().create_timer(1).timeout
	jugador.gravedad.y = 2500
	await get_tree().create_timer(1).timeout
	
	mostrar_marcadores()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	jugador.puede_jugar = true
	jugador.get_node("Contador_municion").visible = true
	await get_tree().create_timer(1).timeout
	
	comenzar_ronda()
	
	await $Salir_o_empezar/Musica1.finished
	$Salir_o_empezar/Musica2.play()
	await $Salir_o_empezar/Musica2.finished
	$Salir_o_empezar/Musica3.play()
	await $Salir_o_empezar/Musica3.finished
	
	banda_sonora()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mostrar_estadisiticas()
	
	if zombies_vivos < 1:
		siguiente_ronda()
	if jugador.salud <= 0:
		derrota()

func comenzar_ronda():
	$Label_siguiente_ronda.visible = true
	$Label_siguiente_ronda.text = "Ronda   " + str(ronda)
	$Sonido_ronda.play()
	generar_zombies_izd()
	generar_zombies_der()
	await get_tree().create_timer(2).timeout
	$Label_siguiente_ronda.visible = false

func siguiente_ronda():
	var random_izq = randf() < 0.5
	if (random_izq):
		zombies_izquierda += randi_range(1, 2)
		
	var random_der = randf() < 0.5
	if (random_der):
		zombies_derecha += randi_range(1, 2)
		
	zombies_totales = zombies_izquierda + zombies_derecha
	zombies_vivos = zombies_totales
	await get_tree().create_timer(5).timeout
	ronda += 1
	
	comenzar_ronda()

func generar_zombies_izd():
	for i in range(zombies_izquierda):
		var aux = zombies.instantiate()
		add_child(aux)
		aux.scale = Vector2(1.15, 1.15)
		aux.global_position = Vector2i(randi_range(-500, -40), 481)
		aux.mod_velocidad = randi_range(0, 30)

func generar_zombies_der():
	for i in range(zombies_derecha):
		var aux = zombies.instantiate()
		add_child(aux)
		aux.scale = Vector2(1.15, 1.15)
		aux.global_position = Vector2i(randi_range(1192, 1652), 481)
		aux.mod_velocidad = randi_range(0, 30)

func mostrar_estadisiticas():
	$Label_ronda.text = "Ronda:   " + str(ronda)
	$Label_zombies_eliminados.text = "Zombies  elminados:   " + str(zombies_eliminados)
	$Label_headshots.text = "Headshots:   " + str(headshots)
	$Label_dinero.text = "Dinero:   " + str(dinero) + "€"

func habilitar_comprar(jugador):
	if jugador.name == "mar_zombies":
		puede_comprar = !puede_comprar
		if puede_comprar:
			$Tienda_municion/Label_precio.visible = true
			$Tienda_municion/Sprites_tienda.play("activada")
		else:
			$Tienda_municion/Label_precio.visible = false
			$Tienda_municion/Sprites_tienda.play("default")

func derrota():
	Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
	$Pausa.set_process_mode(Node.PROCESS_MODE_DISABLED)
	jugador.muerte()
	await get_tree().create_timer(0.5).timeout
	$Label_derrota.visible = true
	await get_tree().create_timer(0.5).timeout
	
	if ronda >= 6 and Global.dificultad_facil:
		$Salir_o_empezar/Botones/Llave_desbloqueada.desbloqueo_zombies()
	elif ronda >= 11 and Global.dificultad_dificil:
		$Salir_o_empezar/Botones/Llave_desbloqueada.desbloqueo_zombies()
	
	if ronda > Global.record_zombies[0]:
		Global.record_zombies[0] = ronda
	elif zombies_eliminados > Global.record_zombies[1]:
		Global.record_zombies[1] = zombies_eliminados
	
	activar_botones()
	get_tree().paused = true

func activar_botones():
	$Salir_o_empezar/Botones/Boton_reiniciar.disabled = false
	$Salir_o_empezar/Botones/Boton_reiniciar.visible = true
	$Salir_o_empezar/Botones/Boton_salir.disabled = false
	$Salir_o_empezar/Botones/Boton_salir.visible = true

func desactivar_botones():
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

func mostrar_salud(value: float) -> void:
	$Label_salud/Barra_salud.value = value
	if jugador.salud <= 0:
		$Label_salud/Label_cantidad.text = "0"
	elif jugador.salud == 500:
		$Label_salud/Label_cantidad.visible = false
	else:
		$Label_salud/Label_cantidad.visible = true
		$Label_salud/Label_cantidad.text = str(jugador.salud)
	
	if jugador.salud == 50:
		jugador.get_node("Sonido_salud_baja").play()

func mostrar_escudo(value: float) -> void:
	$Barra_escudo.value = value
	if jugador.escudo <= 0:
		$Barra_escudo.visible = false
		$Label_cantidad_escudo.visible = false
	elif jugador.escudo == 500:
		$Barra_escudo.visible = true
		$Label_cantidad_escudo.visible = false
	else:
		$Barra_escudo.visible = true
		$Label_cantidad_escudo.visible = true
	
	$Label_cantidad_escudo.text = str(jugador.escudo)

func ocultar_marcadores():
	$Label_ronda.visible = false
	$Label_zombies_eliminados.visible = false
	$Label_headshots.visible = false
	$Label_dinero.visible = false
	$Label_salud.visible = false
	$Barra_escudo.visible = false
	$Label_cantidad_escudo.visible = false

func mostrar_marcadores():
	$Label_ronda.visible = true
	$Label_zombies_eliminados.visible = true
	$Label_headshots.visible = true
	$Label_dinero.visible = true
	$Label_salud.visible = true
	$Label_cantidad_escudo.visible = true

func banda_sonora():
	var musica
	while jugador.salud > 0:
		var random: bool = randf() > 0.5
		if random:
			musica = $Salir_o_empezar/Musica2
			musica.play()
			await musica.finished
		else:
			musica = $Salir_o_empezar/Musica3
			musica.play()
			await musica.finished
	
	if !musica == null:
		await musica.finished
