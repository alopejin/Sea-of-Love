extends Control


@onready var grid = $Cartas

var escena_carta = preload("res://juego1/escenas/carta.tscn")
var cartas = []
var cartas_id = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]
var carta1 = null
var carta2 = null
var juego_activo = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label_resultado.visible = false
	
	if Global.dificultad_dificil:
		$Label_timer.visible = true
	else:
		$Label_timer.visible = false
	
	Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
	$Pausa/Musica.play()
	$Pausa.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	Global.intro = false
	desactivar_botones()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 10)
	cartas_id.shuffle()
	
	for id in cartas_id:
		var carta = escena_carta.instantiate()
		carta.id_carta = id
		grid.add_child(carta)
		
	for i in grid.get_children():
		i.pressed.connect(Callable(self, "carta_volteada").bind(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if juego_activo:
		if $Timer.time_left > 11:
			$Label_timer/Label_tiempo.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		else:
			$Label_timer/Label_tiempo.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		
		$Label_timer/Label_tiempo.text = str(int($Timer.time_left))

func carta_volteada(carta):
		$Sonido_click_cartas.play()
		
		if carta1 == null and !carta.volteada:
			carta1 = carta
			await carta1.voltear()
		elif carta2 == null and !carta.volteada:
			carta2 = carta
			await carta2.voltear()
			await coinciden(carta1, carta2)
			carta1 = null
			carta2 = null
			comprobar_victoria()
		else:
			return

func coinciden(carta1, carta2):
	if(carta1.id_carta == carta2.id_carta):
		carta1.coincide = true
		carta2.coincide = true
	else:
		bloquear_cartas()
		await get_tree().create_timer(0.5).timeout
		$Sonido_fallo.play()
		await get_tree().create_timer(0.5).timeout
		for carta in grid.get_children():
			carta.esconder()
		desbloquear_cartas()

func comprobar_victoria():
	var c = 0
	for i in grid.get_children():
		if i.volteada == true:
			c = c + 1
	
	if c == 12:
		bloquear_cartas()
		if juego_activo:
			juego_activo = false
			var aux = int($Timer.time_left)
			if aux > Global.record_cartas:
				Global.record_cartas = aux
			$Timer.stop()
			$Label_timer/Label_tiempo.text = str(aux)
			$Label_resultado.text = "Has    ganado   : D"
			$Label_resultado.visible = true
		
		$Pausa.set_process_mode(Node.PROCESS_MODE_DISABLED)
		$Llave_desbloqueada.desbloqueo_cartas();
		await get_tree().create_timer(1.5).timeout
		activar_botones()

func bloquear_cartas():
	for carta in grid.get_children():
		carta.disabled = true

func desbloquear_cartas():
	for carta in grid.get_children():
		carta.disabled = false

func derrota():
	bloquear_cartas()
	$Label_resultado.text = "Has    perdido   :("
	$Label_resultado.visible = true
	await get_tree().create_timer(1).timeout
	activar_botones()

func activar_botones():
	$Boton_reiniciar.disabled = false
	$Boton_reiniciar.visible = true
	$Boton_salir.disabled = false
	$Boton_salir.visible = true

func desactivar_botones():
	$Boton_reiniciar.disabled = true
	$Boton_reiniciar.visible = false
	$Boton_salir.disabled = true
	$Boton_salir.visible = false

func reiniciar() -> void:
	$Pausa/Sonido_click.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()

func salir() -> void:
	$Pausa/Sonido_click.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://menu_principal/escenas/menu_principal.tscn")


#https://www.youtube.com/watch?v=EwZnSXwGsS4&list=RDEwZnSXwGsS4&start_radio=1
