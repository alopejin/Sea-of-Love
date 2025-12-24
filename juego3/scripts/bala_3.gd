extends Area2D


const VELOCIDAD := 800

var objetivo
var suelo = preload("res://juego2/escenas/suelo_runner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	borrar_bala()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if objetivo != null:
		global_position += objetivo * VELOCIDAD * delta
		await get_tree().process_frame

func borrar_bala():
	await get_tree().create_timer(2).timeout
	queue_free()

func comprobar_colision(objeto):
	if objeto.name == "suelo_zombies":
		queue_free()
