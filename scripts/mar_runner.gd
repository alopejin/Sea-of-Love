extends CharacterBody2D


@onready var textura_jugador: AnimatedSprite2D = $mar_animacion

const GRAVEDAD = 4200.0
const VELOCIDAD_SALTO = -1200.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta
	if is_on_floor() and get_parent().juego_activo:
		if Input.is_action_just_pressed("saltar"): 
			$Sonido_salto.play()
			velocity.y = VELOCIDAD_SALTO
	
	move_and_slide()
