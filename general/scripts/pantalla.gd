extends Node


func modo_ventana(toggled_on) -> void:
	while DisplayServer.window_get_size() == Vector2i.ZERO:
		await get_tree().process_frame
	
	if toggled_on:
		get_window().set_mode(Window.MODE_WINDOWED)
		print("ventana")
	else:
		get_window().set_mode(Window.MODE_FULLSCREEN)
		print("completa")
