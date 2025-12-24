extends CharacterBody2D


const VELOCIDAD = 700.0

func _physics_process(delta: float) -> void:
	

	var direction := -1.0
	if direction:
		velocity.x = direction * VELOCIDAD
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)

	move_and_slide()
