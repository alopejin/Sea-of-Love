extends Node2D


@onready var jugador = get_parent().get_node("mar_zombies")
@onready var sprites_objetos = ["municion_revolver", "escopeta", "mp40", "botiquin", "escudo"]
@onready var revolver = get_parent().get_node("mar_zombies/Revolver")
@onready var escopeta = get_parent().get_node("mar_zombies/Escopeta")
@onready var mp40 = get_parent().get_node("mar_zombies/MP40")

var puede_comprar = false
var indice: int = 0

var nombres_objetos = ["Municion  de \nrevolver", "Escopeta \nLa   Farmeadora", "Subfusil \nMP40", "Botiquin", "Escudo"]
var precios = [500, 1000, 1500, 1000, 2000]


func habilitar_comprar(jugador):
	if jugador.name == "mar_zombies":
		puede_comprar = !puede_comprar
		if puede_comprar:
			$Tienda_municion/Label_abrir_tienda.visible = true
			$Tienda_municion/Sprites_tienda.play("activada")
		else:
			$Tienda_municion/Label_abrir_tienda.visible = false
			$Tienda_municion/Sprites_tienda.play("default")
			cerrar_tienda()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interactuar") and puede_comprar:
		abrir_tienda()
		Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
		$Tienda_municion/Label_abrir_tienda.visible = false

func abrir_tienda():
	$Sonido_abrir_tienda.play()
	jugador.comprando = true
	$Panel_tienda.visible = true
	mostrar_actual()
	activar_botones()

func cerrar_tienda():
	if $Panel_tienda.visible:
		$Sonido_cerrar_tienda.play()
	jugador.comprando = false
	$Panel_tienda.visible = false
	desactivar_botones()
	Input.set_custom_mouse_cursor(preload("res://juego3/assets/cruceta4-ajustada.png"), Input.CURSOR_ARROW, Vector2(16, 16))

func mostrar_actual():
	$Panel_tienda/Label_nombre.text = nombres_objetos[indice]
	$Panel_tienda/Label_valor.text = str(precios[indice]) + "€"
	$Panel_tienda/Sprites_objetos.visible = true
	$Panel_tienda/Sprites_objetos.play(sprites_objetos[indice]) 

func objeto_izquierda():
	if(indice > 0):
		$Sonido_seleccion.play()
		indice += -1
		mostrar_actual()
	else:
		$Sonido_error_seleccion.play()

func objeto_derecha():
	if(indice < precios.size() - 1):
		$Sonido_seleccion.play()
		indice += 1
		mostrar_actual()
	else:
		$Sonido_error_seleccion.play()

func sustituir_objeto():
	if indice == 1:
		nombres_objetos[indice] = "Municion  de \nescopeta"
		precios[indice] = 600
		sprites_objetos[indice] = "municion_escopeta"
	
	elif indice == 2:
		nombres_objetos[indice] = "Municion  de \nMP40"
		precios[indice] = 700
		sprites_objetos[indice] = "municion_mp40"
	
	mostrar_actual()

func comprar():
	if get_parent().dinero >= precios[indice]:
		$Tienda_municion/Sonido_compra.play()
		
		if indice == 0:
			revolver.cargadores += 2
			get_parent().dinero += -precios[indice]
			jugador.mostrar_compra(precios[indice])
		
		if indice == 1 and !jugador.arma2_desbloqueada:
			jugador.arma2_desbloqueada = true
			get_parent().dinero += -precios[indice]
			jugador.mostrar_compra(precios[indice])
			sustituir_objeto()
		elif indice == 1:
			get_parent().dinero += -precios[indice]
			jugador.mostrar_compra(precios[indice])
			escopeta.cartuchos += 20
		
		if indice == 2 and !jugador.arma3_desbloqueada:
			jugador.arma3_desbloqueada = true
			get_parent().dinero += -precios[indice]
			jugador.mostrar_compra(precios[indice])
			sustituir_objeto()
		elif indice == 2:
			get_parent().dinero += -precios[indice]
			jugador.mostrar_compra(precios[indice])
			mp40.cargadores += 2
		
		if indice == 3 and jugador.salud < 500:
			jugador.get_node("Sonido_curacion").play()
			jugador.salud = 500
			get_parent().dinero += -precios[indice]
			get_parent().get_node("Label_salud/Barra_salud").value = jugador.salud
			jugador.mostrar_compra(precios[indice])
		
		if indice == 4  and jugador.escudo < 500:
			jugador.activar_escudo()
			get_parent().mostrar_escudo(jugador.escudo)
			get_parent().dinero += -precios[indice]
			jugador.mostrar_compra(precios[indice])
		
	else:
		$Sonido_no_money.play()
	
	animacion_compra()

func animacion_compra():
	get_parent().get_node("Label_dinero").set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))
	get_parent().get_node("Label_dinero/AnimationPlayer").play("dinero")
	await get_parent().get_node("Label_dinero/AnimationPlayer").animation_finished
	get_parent().get_node("Label_dinero").set("theme_override_colors/font_color", Color(0.0,1.0,0.0,1.0))

func activar_botones():
	$Panel_tienda/Boton_izquierda.disabled = false
	$Panel_tienda/Boton_derecha.disabled = false
	$Panel_tienda/Boton_comprar.disabled = false

func desactivar_botones():
	$Panel_tienda/Boton_izquierda.disabled = true
	$Panel_tienda/Boton_derecha.disabled = true
	$Panel_tienda/Boton_comprar.disabled = true
