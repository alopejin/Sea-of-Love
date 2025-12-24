extends Node


func _input(event):
	if event.is_action_pressed("pausar"):
		if get_tree().paused:
			if get_parent().name == "main_zombies":
				Input.set_custom_mouse_cursor(preload("res://juego3/assets/cruceta4-ajustada.png"), Input.CURSOR_ARROW, Vector2(16, 16))
			elif get_parent().name == "main_runner":
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			else:
				Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
		
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
			$Sonido_menu.play()
		
		alternar_menu()
		get_tree().paused = !get_tree().paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alternar_menu()

func reiniciar() -> void:
	$Sonido_click.play()
	await $Sonido_click.finished
	get_tree().paused = false
	var escena_actual = get_tree().current_scene
	var ruta = escena_actual.scene_file_path
	alternar_menu()
	get_tree().change_scene_to_file(ruta)

func salir() -> void:
	$Sonido_click.play()
	get_tree().paused = false
	alternar_menu()
	get_tree().change_scene_to_file("res://menu_principal/escenas/menu_principal.tscn")

func abrir_ajustes() -> void:
	$Sonido_click.play()
	$Ajustes.ajustes_abiertos = true
	alternar_menu()
	$Ajustes.alternar_ajustes_globales()

func reanudar() -> void:
	if get_parent().name == "main_zombies":
		Input.set_custom_mouse_cursor(preload("res://juego3/assets/cruceta4-ajustada.png"), Input.CURSOR_ARROW, Vector2(16, 16))
	else:
		Input.set_custom_mouse_cursor(preload("res://general/assets/cursor3-ajustado.png"), Input.CURSOR_ARROW, Vector2(0,0))
	
	$Sonido_click.play()
	alternar_menu()
	get_tree().paused = !get_tree().paused

func alternar_menu():
	$Menu_pausa.visible = !$Menu_pausa.visible
