extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LLave_imagen.visible = false
	$Llave_texto.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func desbloqueo_cartas():
	if Global.juego_cartas_ganado == false:
		animacion_desbloqueo()
		Global.llaves_conseguidas += 1
		Global.juego_cartas_ganado = true

func desbloqueo_saltar():
	if Global.juego_saltar_ganado == false:
		animacion_desbloqueo()
		Global.llaves_conseguidas += 1
		Global.juego_saltar_ganado = true

func desbloqueo_zombies():
	if Global.juego_zombies_ganado == false:
		animacion_desbloqueo()
		Global.llaves_conseguidas += 1
		Global.juego_zombies_ganado = true

func animacion_desbloqueo():
	$Sonido_desbloqueo.play()
	$LLave_imagen.visible = true
	$LLave_imagen/Animacion_llave.play("desbloqueo")
	await get_tree().create_timer(1).timeout
	$Llave_texto.visible = true
