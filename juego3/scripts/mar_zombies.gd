extends CharacterBody2D


@onready var textura_jugador: AnimatedSprite2D = $mar_animacion

const VELOCIDAD_SALTO = -700.0
const VELOCIDAD_MAX = 100

var ultima_dir = Vector2(1,0)
var gravedad = Vector2 (0, 700)

var arma2_desbloqueada = false
var arma3_desbloqueada = false

var arma1_seleccionada = true
var arma2_seleccionada = false
var arma3_seleccionada = false

var puede_jugar = false
var comprando = false
var escudo_activo = false
var salud = 500
var escudo = 0

func _ready() -> void:
	$Contador_municion.visible = false
	$Compra.visible = false

func _process(delta: float) -> void:
	mostrar_municion()
	if arma3_seleccionada and !comprando:
			if Input.is_action_pressed("disparar") and !$MP40.recargando:	
				$MP40.disparar()
	
func _physics_process(delta: float) -> void:
	if salud > 0:
		if not is_on_floor():
			velocity += gravedad * delta
			
		if Input.is_action_just_pressed("saltar") and is_on_floor():
			$Sonido_salto.play()
			velocity.y = VELOCIDAD_SALTO
		
		var direccion = Input.get_axis("mover_izquierda", "mover_derecha")
		velocity.x = direccion * VELOCIDAD_MAX
	
		if direccion:
			velocity.x = direccion * VELOCIDAD_MAX
		else:
			velocity.x = move_toward(velocity.x, 0, VELOCIDAD_MAX)
		
		move_and_slide()
		
		if direccion == 1.0:
			textura_jugador.flip_h = false
		elif direccion == -1.0:
			textura_jugador.flip_h = true
	
	if escudo <= 0 and escudo_activo:
		desactivar_escudo()

func _input(event: InputEvent) -> void:
	if salud > 0 and puede_jugar:
		
		if !comprando:
			if event.is_action_pressed("disparar"):
				if arma1_seleccionada and !$Revolver.recargando:
					$Revolver.disparar()
				
				if arma2_seleccionada and !$Escopeta.recargando:
					$Escopeta.disparar()
				
			if Input.is_action_just_pressed("recargar"):
				if arma1_seleccionada:
					if !$Revolver.recargando:
						$Revolver.recargando = true
						await $Revolver.recargar()
						
				if arma2_seleccionada:
					if !$Escopeta.recargando:
						$Escopeta.recargando = true
						await $Escopeta.recargar()
						
				if arma3_seleccionada:
					if !$MP40.recargando:
						$MP40.recargando = true
						await $MP40.recargar()
		
		if Input.is_action_pressed("mover_izquierda") or Input.is_action_pressed("mover_derecha"):
			if salud >= 400:
				$mar_animacion.play("vestido_verde")
			elif salud < 400 and salud >= 200:
				$mar_animacion.play("sangriento1")
			else: 
				$mar_animacion.play("sangriento2")
			
		if Input.is_action_just_pressed("arma1") and !$Escopeta.recargando and !$MP40.recargando:
			arma1_seleccionada = true
			$Revolver.visible = true
			arma2_seleccionada = false
			$Escopeta.visible = false
			arma3_seleccionada = false
			$MP40.visible = false
			
		if Input.is_action_just_pressed("arma2") and arma2_desbloqueada and !$Revolver.recargando and !$MP40.recargando:
			arma1_seleccionada = false
			$Revolver.visible = false
			arma2_seleccionada = true
			$Escopeta.visible = true
			arma3_seleccionada = false
			$MP40.visible = false
			
		if Input.is_action_just_pressed("arma3") and arma3_desbloqueada and !$Revolver.recargando and !$Escopeta.recargando:
			arma1_seleccionada = false
			$Revolver.visible = false
			arma2_seleccionada = false
			$Escopeta.visible = false
			arma3_seleccionada = true
			$MP40.visible = true

func mostrar_municion():
	if arma1_seleccionada:
		$Contador_municion.text = "Cargadores:   " + str($Revolver.cargadores) + ",   Balas   restantes:   " + str($Revolver.balas_cargador)
	elif arma2_seleccionada:
		$Contador_municion.text = "Cartuchos:   " + str($Escopeta.cartuchos) + ",   Recamara:   " + str($Escopeta.recamara)
	else:
		$Contador_municion.text = "Cargadores:   " + str($MP40.cargadores) + ",   Balas   restantes:   " + str($MP40.balas_cargador)

func muerte():
	$LightOccluder2D.visible = false
	$Contador_municion.visible = false
	$Revolver.visible = false
	$Escopeta.visible = false
	$MP40.visible = false
	$mar_zombies/CollisionShape2D.set_deferred("monitoring", false)
	$Grito_derrota.play()
	$mar_animacion.play("muerta")
	$mar_animacion/Animaciones.play("muerte")

func activar_escudo():
	$Sonido_activar_escudo.play()
	get_parent().get_node("Barra_escudo").visible = true
	escudo = 500
	escudo_activo = true
	$Escudo.visible = true

func desactivar_escudo():
	$Sonido_desactivar_escudo.play()
	escudo_activo = false
	$Escudo.visible = false

func mostrar_compra(valor):
	$Compra.visible = true
	$Compra.text = "-" + str(valor) + "€"
	
	if !textura_jugador.flip_h:
		$Compra/AnimationPlayer.play("compra")
		await $Compra/AnimationPlayer.animation_finished
	else:
		$Compra/AnimationPlayer.play("compra_invertida")
		await $Compra/AnimationPlayer.animation_finished
	
	$Compra.visible = false
