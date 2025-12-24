extends CharacterBody2D


@onready var rugidos = [$Sonido_rugido1, $Sonido_rugido2, $Sonido_rugido3]
@onready var jugador = get_parent().get_node("mar_zombies")

const GRAVEDAD = 3000.0
const VELOCIDAD_MAX = 200
const SALUD_MAX = 300
const VELOCIDAD_INICAL = 50
const SALUD_INICIAL = 100

var velocidad : float = 90.0
var salud : int
var mod_velocidad : int
var atacando : bool
var derecha : bool = true
var ultimo_impacto_cabeza : bool = false
var vivo : bool = true


func _ready() -> void:
	$Soporte_animaciones/Animacion_cabeza.sprite_frames = $Soporte_animaciones/Animacion_cabeza.sprite_frames.duplicate(true)
	$Soporte_animaciones/Animacion_piernas.play("lento")
	$Soporte_animaciones/Animacion_cabeza.play("default")
	$Soporte_animaciones/Animacion_cuerpo.play("default")
	var rugido_prob = randf() < 0.5
	if (rugido_prob):
		rugir()
	mod_velocidad = randi_range(0, 30)
	velocidad = VELOCIDAD_INICAL + mod_velocidad
	salud = SALUD_INICIAL

func _physics_process(delta: float) -> void:
	var dir_x = sign(jugador.global_position.x - global_position.x)
	velocity.x = dir_x * velocidad
	
	move_and_slide()
	
	if dir_x > 0 and !atacando and !derecha and salud > 0:
		derecha = true
		$Soporte_animaciones/Animacion_cabeza.position = Vector2(-6, -46)
		$Soporte_animaciones/Animacion_piernas.flip_h = false
		$Soporte_animaciones/Animacion_cabeza.flip_h = false
		$Soporte_animaciones/Animacion_cuerpo.flip_h = false
		hitbox_izq()
		
	elif dir_x < -0 and !atacando and derecha and salud > 0:
		derecha = false
		$Soporte_animaciones/Animacion_cabeza.position = Vector2(1, -46)
		$Soporte_animaciones/Animacion_piernas.flip_h = true
		$Soporte_animaciones/Animacion_cabeza.flip_h = true
		$Soporte_animaciones/Animacion_cuerpo.flip_h = true
		hitbox_der()
	
	if salud <= 0:
		$Timer_rugido.autostart = false
		$Timer_ataque.stop()
		velocidad = 0
		$Hitbox_cuerpo.set_deferred("monitoring", false)
		$Hitbox_cabeza.set_deferred("monitoring", false)
		$Hitbox_cuerpo_invertida.set_deferred("monitoring", false)
		$Hitbox_cabeza_invertida.set_deferred("monitoring", false)
		if vivo:
			confirmar_muerte()

func confirmar_muerte():
	vivo = false
	if ultimo_impacto_cabeza:
			await explotar_cabeza()
	await muerte()
	get_parent().zombies_eliminados += 1
	get_parent().zombies_vivos += -1
	queue_free()

func disparo_cuerpo(bala: Area2D):
	if bala.name == ("Bala"):
		ultimo_impacto_cabeza = false
		$Sonido_impacto_cuerpo.play()
		
		if jugador.arma1_seleccionada:
			$Dinero.text = "+25€"
			get_parent().dinero += 25
			salud += -50
			
		elif jugador.arma2_seleccionada:
			$Dinero.text = "+50€"
			get_parent().dinero += 50
			salud += -200
			
		elif jugador.arma3_seleccionada:
			$Dinero.text = "+5€"
			get_parent().dinero += 5
			salud += -25
		
		if $Soporte_animaciones/Animacion_cuerpo.flip_h:
			$Dinero/AnimationPlayer.play("dinero_invertido")
		else:
			$Dinero/AnimationPlayer.play("dinero")
			
		animacion_dinero()
		bala.queue_free()

func disparo_cabeza(bala: Area2D):
	if bala.name == ("Bala"):
		ultimo_impacto_cabeza = true
		$Sonido_headshot.play()
		
		if jugador.arma1_seleccionada:
			$Dinero.text = "+50€"
			get_parent().dinero += 50
			salud += -100
			
		elif jugador.arma2_seleccionada:
			$Dinero.text = "+100€"
			get_parent().dinero += 100
			salud += -200
			
		elif jugador.arma3_seleccionada:
			$Dinero.text = "+15€"
			get_parent().dinero += 15
			salud += -50
			
		if $Soporte_animaciones/Animacion_cuerpo.flip_h:
			$Dinero/AnimationPlayer.play("dinero_invertido")
		else:
			$Dinero/AnimationPlayer.play("dinero")
				
		animacion_dinero()
		get_parent().headshots += 1
		bala.queue_free()

func animacion_dinero():
	get_parent().get_node("Label_dinero").set("theme_override_colors/font_color", Color(0.0,1.0,0.0,1.0))
	get_parent().get_node("Label_dinero/AnimationPlayer").play("dinero")

func ataque(jugador: CharacterBody2D):
	if jugador.name == ("mar_zombies"):
		atacando = !atacando
		if atacando:
			velocidad = 0
			$Timer_ataque.start()
			
			if jugador.salud > 0:
				if !jugador.escudo_activo:
					jugador.get_node("Sonido_queja").play()
					jugador.salud += -50
					get_parent().mostrar_salud(jugador.salud)
				else:
					jugador.get_node("Sonido_golpe_escudo").play()
					jugador.escudo += -50
					get_parent().mostrar_escudo(jugador.escudo)
			
		else:
			velocidad = VELOCIDAD_INICAL + mod_velocidad
			$Timer_ataque.stop()

func confirmar_ataque():
	#$Animacion_ataque.play()
	if !jugador.escudo_activo:
		jugador.salud = 0
		get_parent().mostrar_salud(jugador.salud)
	else:
		jugador.escudo = 0
		get_parent().mostrar_escudo(jugador.escudo)

func rugir():
	var r = randf() > 0.5
	if r:
		var rugido = rugidos[randi() % rugidos.size()]
		rugido.play()

func hitbox_izq():
	$Hitbox_cuerpo_invertida.set_deferred("monitoring", false)
	$Hitbox_cabeza_invertida.set_deferred("monitoring", false)
	$Hitbox_cuerpo.set_deferred("monitoring", true)
	$Hitbox_cabeza.set_deferred("monitoring", true)

func hitbox_der():
	$Hitbox_cuerpo.set_deferred("monitoring", false)
	$Hitbox_cabeza.set_deferred("monitoring", false)
	$Hitbox_cuerpo_invertida.set_deferred("monitoring", true)
	$Hitbox_cabeza_invertida.set_deferred("monitoring", true)

func explotar_cabeza():
	$Soporte_animaciones/Animacion_cabeza.play("explotando")
	await $Soporte_animaciones/Animacion_cabeza.animation_finished
	$Soporte_animaciones/Animacion_cabeza.play("explotada")

func muerte():
	$Soporte_animaciones/Animacion_piernas.stop()
	$Soporte_animaciones/Animacion_cuerpo.stop()
	if $Soporte_animaciones/Animacion_cuerpo.flip_h:
		$Soporte_animaciones/Animacion_muerte.play("muerte_invertida")
	else:
		$Soporte_animaciones/Animacion_muerte.play("muerte")
	
	await $Soporte_animaciones/Animacion_muerte.animation_finished
