extends Node2D


const BALA = preload("res://juego3/escenas/bala3.tscn") 

var raton_pos
var cartuchos : int
var recamara : int
var recargando: bool
var puede_disparar: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	cartuchos = 20
	recamara = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apuntar()

func apuntar():
	raton_pos = get_global_mouse_position()
	look_at(raton_pos)
	
	if raton_pos.x < get_parent().global_position.x:
		position = Vector2(0, 20)
		$Sprites.flip_v = true
	else:
		$Sprites.flip_v = false
		position = Vector2(0, 0)

func disparar():
	if recamara > 0 and puede_disparar:
		$Timer.start()
		$Sprites.play("disparo")
		$Sonido_disparo.play()
		var bala1 = BALA.instantiate()
		var bala2 = BALA.instantiate()
		var bala3 = BALA.instantiate()
		bala1.get_node("Texturas").scale = Vector2(0.3, 0.3) 
		bala1.get_node("Texturas").play("escopeta")
		bala2.get_node("Texturas").scale = Vector2(0.3, 0.3) 
		bala2.get_node("Texturas").play("escopeta")
		bala3.get_node("Texturas").scale = Vector2(0.3, 0.3) 
		bala3.get_node("Texturas").play("escopeta")
		
		if raton_pos.x < get_parent().global_position.x:
			bala1.position.x = $Marker2D.global_position.x
			bala1.position.y = $Marker2D.global_position.y - 15
			var direccion1 = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y)
			bala1.objetivo = direccion1.normalized()
			
			bala2.position.x = $Marker2D.global_position.x
			bala2.position.y = $Marker2D.global_position.y - 15
			var direccion2 = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y + 15)
			bala2.objetivo = direccion2.normalized()
			
			bala3.position.x = $Marker2D.global_position.x
			bala3.position.y = $Marker2D.global_position.y - 15
			var direccion3 = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y + 30)
			bala3.objetivo = direccion1.normalized()
		else:
			bala1.position = $Marker2D.global_position
			bala1.objetivo = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y - 15).normalized()
			
			bala2.position = $Marker2D.global_position
			bala2.objetivo = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y).normalized()
			
			bala3.position = $Marker2D.global_position
			bala3.objetivo = Vector2(get_global_mouse_position().x - $Marker2D.global_position.x, get_global_mouse_position().y - $Marker2D.global_position.y + 15).normalized()
			
		get_tree().root.add_child(bala1)
		get_tree().root.add_child(bala2)
		get_tree().root.add_child(bala3)
		
		recamara += -1
		puede_disparar = false
	
	elif recamara == 0:
		$Sonido_cargador_vacio.play()

func recargar():
	if cartuchos > 1:
		if recamara == 0:
			$Sonido_recarga.play()
			await get_tree().create_timer(1).timeout
			$Sonido_recarga.play()
			await get_tree().create_timer(1).timeout
			$Sprites.play("cocking")
			$Sonido_cocking.play()
			cartuchos += -2
			recamara = 2
			recargando = false
			
		elif recamara == 1:
			$Sonido_recarga.play()
			await get_tree().create_timer(1).timeout
			$Sprites.play("cocking")
			$Sonido_cocking.play()
			cartuchos += -1
			recamara = 2
			recargando = false
			
		elif recamara == 2:
			recargando = false
		
	elif cartuchos == 1:
		$Sonido_recarga.play()
		await get_tree().create_timer(1).timeout
		$Sprites.play("cocking")
		$Sonido_cocking.play()
		cartuchos += -1
		recamara += 1
		recargando = false
	
	else:
		recargando = false

func timer_disparo() -> void:
	puede_disparar = true
	if recamara > 0:
		$Sprites.play("cocking")
		$Sonido_cocking.play()
