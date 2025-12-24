extends Node2D


const BALA = preload("res://juego3/escenas/bala3.tscn") 

var raton_pos
var cargadores : int
var balas_cargador : int
var recargando : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cargadores = 5
	balas_cargador = 6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apuntar()

func apuntar():
	raton_pos = get_global_mouse_position()
	look_at(raton_pos)
	if raton_pos.x < get_parent().global_position.x:
		$Sprites.flip_v = true
	else:
		$Sprites.flip_v = false

func disparar():
	if balas_cargador > 0:
		$Sprites.play("disparo")
		$Sonido_disparo.play()
		var aux = BALA.instantiate()
		aux.get_node("Texturas").scale = Vector2(0.6, 0.6) 
		aux.get_node("Texturas").play("revolver")
		
		if raton_pos.x < get_parent().global_position.x:
			aux.position.x = $Marker2D.global_position.x
			aux.position.y = $Marker2D.global_position.y - 15
			var direccion = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y + 15)
			aux.objetivo = direccion.normalized()
		else:
			aux.position = $Marker2D.global_position
			aux.objetivo = (get_global_mouse_position() - $Marker2D.global_position).normalized()
		get_tree().root.add_child(aux)
		balas_cargador += -1
		await $Sonido_disparo.finished
	
	else:
		$Sonido_cargador_vacio.play()

func recargar():
	if cargadores > 0:
		if balas_cargador < 6:
			$Sonido_recarga.play()
			await get_tree().create_timer(3).timeout
			cargadores += -1
			balas_cargador = 6
			recargando = false
		else:
			recargando = false
	
	else:
		recargando = false
