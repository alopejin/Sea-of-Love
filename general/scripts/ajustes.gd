extends Node


var ajustes_abiertos = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alternar_ajustes_globales()
	esconder_ajustes_sonido()
	esconder_ajustes_pantalla()

func _input(event):
	if event.is_action_pressed("pausar") and ajustes_abiertos:
		if get_parent() and get_parent().has_method("alternar_menu"):
			get_parent().alternar_menu()
			$Opciones_ajustes.visible = false
			esconder_ajustes_sonido()
			esconder_ajustes_pantalla()
			ajustes_abiertos = false

func alternar_ajustes_globales():
	$Opciones_ajustes.visible = !$Opciones_ajustes.visible

func volver_menu_principal():
	$Sonido_click.play()
	alternar_ajustes_globales()
	if get_parent() and get_parent().has_method("alternar_menu"):
		ajustes_abiertos = false
		get_parent().alternar_menu()

func salir_ajustes_sonido():
	$Sonido_click.play()
	esconder_ajustes_sonido()
	alternar_ajustes_globales()

func mostrar_ajustes_sonido():
	$Sonido_click.play()
	alternar_ajustes_globales()
	$Opciones_sonido.visible = true

func esconder_ajustes_sonido():
	$Opciones_sonido.visible = false

func mostrar_ajustes_pantalla():
	$Sonido_click.play()
	alternar_ajustes_globales()
	$Opciones_pantalla.visible = true

func esconder_ajustes_pantalla():
	$Opciones_pantalla.visible = false

func modo_ventana(toggled_on: bool) -> void:
	if toggled_on:
		get_window().set_mode(Window.MODE_WINDOWED)
	else:
		get_window().set_mode(Window.MODE_FULLSCREEN)

func cerrar_ajustes_pantalla() -> void:
	$Sonido_click.play()
	esconder_ajustes_pantalla()
	alternar_ajustes_globales()

func pantalla_predeterminados():
	$Opciones_pantalla/controlador_brillo.set_value(1.0)
	$Opciones_pantalla/controlador_contraste.set_value(1.0)
	$Opciones_pantalla/controlador_saturacion.set_value(1.0)
