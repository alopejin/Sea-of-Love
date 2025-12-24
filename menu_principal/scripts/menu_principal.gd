extends Control


var cofre_abierto : bool = false
var version_original : bool = false
var puede_salir : bool = true

func _ready():
	comprobar_llaves()
	Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
	$Boton_juego1.texture_normal = preload("res://menu_principal/assets/captura_cartas1.png")
	$Boton_juego1.texture_hover = preload("res://menu_principal/assets/captura_cartas1-hover.png")
	$Boton_juego1.position = Vector2(462, 266)
	$Boton_juego1.z_index = 0
	$Boton_juego2.texture_normal = preload("res://menu_principal/assets/captura_runner1_corregida.png")
	$Boton_juego2.texture_hover = preload("res://menu_principal/assets/captura_runner1-corregida-hover.png")
	$Boton_juego2.position = Vector2(184, 266)
	$Boton_juego2.z_index = 0
	$Boton_juego3.texture_normal = preload("res://menu_principal/assets/captura_zombies1.png")
	$Boton_juego3.texture_hover = preload("res://menu_principal/assets/captura_zombies1-hover.png")
	$Boton_juego3.position = Vector2(742, 266)
	$Boton_juego3.z_index = 0
	$Salir_juego.visible = false
	$Boton_introduccion.visible = false
	$Mensaje_inicial.visible = false
	$Recordar_dificultad.visible = false
	$Configuracion/Boton_configuracion.disabled = false
	$Configuracion/Boton_configuracion.visible = false 
	$Textura_titulo.visible = false
	$Boton_cofre/Texturas_cofre.visible = false
	$Spoiler.visible = false
	$Mar.visible = false
	$Elegir_version.visible = false
	$Boton_records.visible = false
	
	if Global.juego_cartas_ganado:
		$Boton_juego1/Ganado.visible = true
	else:
		$Boton_juego1/Ganado.visible = false
	
	if Global.juego_saltar_ganado:
		$Boton_juego2/Ganado.visible = true
	else:
		$Boton_juego2/Ganado.visible = false
	
	if Global.juego_zombies_ganado:
		$Boton_juego3/Ganado.visible = true
	else:
		$Boton_juego3/Ganado.visible = false
	
	if Global.intro:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$Video_intro.show()
		$Video_intro.play()
		await $Video_intro.finished
		$Video_intro.hide()
		$Video_intro.visible = false
		$Textura_titulo.visible = true
		$Mar.visible = true
		$Boton_introduccion.visible = true
		$Boton_records.visible = true
		$Configuracion/Boton_configuracion.disabled = false
		$Configuracion/Boton_configuracion.visible = true 
		$Boton_cofre/Texturas_cofre.visible = true
		$Boton_cofre/Texturas_cofre.play("default")
		$Musica_inicial.play()
		alternar_botones()
		await get_tree().create_timer(2.0).timeout
		$Mensaje_inicial.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.intro = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Textura_titulo.visible = true
		$Mar.visible = true
		$Configuracion/Boton_configuracion.disabled = false
		$Configuracion/Boton_configuracion.visible = true
		$Boton_introduccion.visible = true
		$Boton_records.visible = true
		$Boton_cofre/Texturas_cofre.visible = true
		$Boton_cofre/Texturas_cofre.play("default")
		$Sonido_fondo.play()
		$Video_intro.hide()

func comprobar_llaves() -> void:
	$Animacion_llave1.visible = false
	$Animacion_llave2.visible = false
	$Animacion_llave3.visible = false
	$LLaves_conseguidas.visible = false
	
	if Global.llaves_conseguidas == 1:
		$Animacion_llave1.visible = true
		$LLaves_conseguidas.visible = true
	elif Global.llaves_conseguidas == 2:
		$Animacion_llave1.visible = true
		$Animacion_llave2.visible = true
		$LLaves_conseguidas.visible = true
	elif Global.llaves_conseguidas == 3:
		$Animacion_llave1.visible = true
		$Animacion_llave2.visible = true
		$Animacion_llave3.visible = true
		$LLaves_conseguidas.visible = true

func cargar_juego_cartas() -> void:
	if Global.dificultad_facil or Global.dificultad_dificil:
		puede_salir = false
		$Boton_juego1/Ganado.visible = false
		$Boton_juego1/Boton_tutorial.visible = false
		$Boton_juego1.z_index = 100
		$Boton_juego1.texture_normal = preload("res://menu_principal/assets/captura_cartas2.png")
		$Boton_juego1.texture_hover = null
		$Boton_juego1/AnimationPlayer.play("abrir_juego")
		await $Boton_juego1/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://juego1/escenas/juegocartas.tscn")
	else:
		recordar_dificultad()

func cargar_juego_runner() -> void:
	if Global.dificultad_facil or Global.dificultad_dificil:
		puede_salir = false
		$Boton_juego2/Ganado.visible = false
		$Boton_juego2/Boton_tutorial.visible = false
		$Boton_juego2.z_index = 100
		$Boton_juego2.texture_normal = preload("res://menu_principal/assets/captura_runner2.png")
		$Boton_juego2.texture_hover = null
		$Boton_juego2/AnimationPlayer.play("abrir_juego")
		await $Boton_juego2/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://juego2/escenas/main_runner.tscn")
	else:
		recordar_dificultad()

func cargar_juego_zombies() -> void:
	puede_salir = false
	alternar_menu_version()
	$Boton_juego3/Ganado.visible = false
	$Boton_juego3/Boton_tutorial.visible = false
	$Boton_juego3.z_index = 100
	$Boton_juego3.texture_normal = preload("res://menu_principal/assets/captura_zombies2.png")
	$Boton_juego3.texture_hover = null
	$Boton_juego3/AnimationPlayer.play("abrir_juego")
	await $Boton_juego3/AnimationPlayer.animation_finished
	
	if version_original:
		get_tree().change_scene_to_file("res://juego3/escenas/main_zombies.tscn")
	else:
		get_tree().change_scene_to_file("res://juego3/escenas/main_zombies2.tscn")

func elegir_version_original():
	version_original = true
	cargar_juego_zombies()

func alternar_menu_version():
	if Global.dificultad_facil or Global.dificultad_dificil:
		if !$Elegir_version.visible:
			$Sonido_menu.play()
		else:
			$Sonido_click.play()
		
		$Elegir_version.visible = !$Elegir_version.visible
		alternar_botones()
		puede_salir = !puede_salir
	
	else:
		recordar_dificultad()

func boton_introduccion() -> void:
	puede_salir = !puede_salir
	alternar_botones()
	$Sonido_click.play()
	$Mensaje_inicial.visible = !$Mensaje_inicial.visible

func recordar_dificultad():
	puede_salir = !puede_salir
	if !$Recordar_dificultad.visible:
		$Sonido_advertencia.play()
	else:
		$Sonido_click.play()
	
	$Recordar_dificultad.visible = !$Recordar_dificultad.visible
	alternar_botones()

func dificultad_facil_aviso():
	$Sonido_click.play()
	recordar_dificultad()
	Global.dificultad_facil = true
	Global.dificultad_dificil = false
	Global.llaves_conseguidas = 0
	Global.juego_cartas_ganado = false
	Global.juego_saltar_ganado = false
	Global.juego_zombies_ganado = false

func dificultad_dificil_aviso():
	$Sonido_click.play()
	recordar_dificultad()
	Global.dificultad_facil = false
	Global.dificultad_dificil = true
	Global.llaves_conseguidas = 0
	Global.juego_cartas_ganado = false
	Global.juego_saltar_ganado = false
	Global.juego_zombies_ganado = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pausar") and !Global.intro and puede_salir:
		if !$Salir_juego.visible:
			$Sonido_salir.play()
		$Salir_juego.visible = !$Salir_juego.visible
		alternar_botones()
		
func alternar_botones():
	$Boton_introduccion.disabled = !$Boton_introduccion.disabled
	$Configuracion.get_node("Boton_configuracion").disabled = !$Configuracion.get_node("Boton_configuracion").disabled
	$Boton_cofre.disabled = !$Boton_cofre.disabled
	$Boton_juego1.disabled = !$Boton_juego1.disabled
	$Boton_juego2.disabled = !$Boton_juego2.disabled
	$Boton_juego3.disabled = !$Boton_juego3.disabled
	$Boton_juego1/Boton_tutorial.disabled = !$Boton_juego1/Boton_tutorial.disabled
	$Boton_juego2/Boton_tutorial.disabled = !$Boton_juego2/Boton_tutorial.disabled
	$Boton_juego3/Boton_tutorial.disabled = !$Boton_juego3/Boton_tutorial.disabled
	$Boton_records.disabled = !$Boton_records.disabled

func cerrar_juego():
	$Sonido_click.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func cancelar_salir():
	alternar_botones()
	$Sonido_click.play()
	$Salir_juego.visible = false

func abrir_cofre():
	if Global.llaves_conseguidas == 3 and !cofre_abierto:
		alternar_botones()
		$Boton_cofre.disabled = !$Boton_cofre.disabled
		cofre_abierto = true
		$Boton_cofre/Texturas_cofre.play("llaves")
		$Boton_cofre/Texturas_cofre/Sonido_llave_cerradura.play()
		await $Boton_cofre/Texturas_cofre/Sonido_llave_cerradura.finished
		$Boton_cofre/Texturas_cofre/Sonido_abrir.play()
		await $Boton_cofre/Texturas_cofre/Sonido_abrir.finished
		$Boton_cofre/Texturas_cofre.play("abierto")
		await get_tree().create_timer(0.2).timeout
		$Spoiler/AnimationPlayer.play("desbloqueo")
	
	elif cofre_abierto:
		alternar_botones()
		$Boton_cofre.disabled = !$Boton_cofre.disabled
		cofre_abierto = false
		$Spoiler/AnimationPlayer.play("guardar")
		await $Spoiler/AnimationPlayer.animation_finished
		$Spoiler.visible = false
		await get_tree().create_timer(0.2).timeout
		$Boton_cofre/Texturas_cofre.play("default")
		$Boton_cofre/Texturas_cofre/Sonido_cerrar.play()
	
	else:
		alternar_advertencia_llaves()

func alternar_advertencia_llaves():
	if $Advertencia_llaves.visible:
		$Sonido_click.play()
	else:
		$Sonido_error.play()
	
	$Advertencia_llaves.visible = !$Advertencia_llaves.visible
	puede_salir = !puede_salir
	alternar_botones()

func alternar_tutorial1():
	puede_salir = !puede_salir
	$Sonido_click.play()
	$Boton_juego1/Tutorial.visible = !$Boton_juego1/Tutorial.visible
	alternar_botones()

func alternar_tutorial2():
	puede_salir = !puede_salir
	$Sonido_click.play()
	$Boton_juego2/Tutorial.visible = !$Boton_juego2/Tutorial.visible
	alternar_botones()

func alternar_tutorial3():
	puede_salir = !puede_salir
	$Sonido_click.play()
	$Boton_juego3/Tutorial.visible = !$Boton_juego3/Tutorial.visible
	alternar_botones()

func alternar_records():
	puede_salir = !puede_salir
	alternar_botones()
	
	if Global.dificultad_dificil or Global.dificultad_facil:
		$Records.visible = !$Records.visible
		$Sonido_click.play()
		
		if Global.dificultad_dificil: 
			$Records/Label_dificultad.text = "-Dificultad: Pro gamer 300IQ"
			$Records/Label_record_cartas.visible = true
			$Records/Label_record_cartas.text = "-Love Cards: " + str(Global.record_cartas) + " segundos restantes."
		elif Global.dificultad_facil:
			$Records/Label_dificultad.text = "-Dificultad: Sin brazos"
			$Records/Label_record_cartas.visible = false
		
		$Records/Label_record_saltar.text = "-Problem Jumper: " + str(Global.record_saltar) + " puntos."
		$Records/Label_record_zombies.text = "-A lady and a revolver: " + str(Global.record_zombies[0]) + " rondas sobrevividas, \n" + str(Global.record_zombies[1]) + " zombies eliminados."
		
	else:
		$Advertencia_records.visible = !$Advertencia_records.visible
		if $Advertencia_records.visible:
			$Sonido_advertencia.play()
		else:
			$Sonido_click.play()
	
