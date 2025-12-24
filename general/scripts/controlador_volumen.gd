extends HSlider


@export
var bus_nombre : String
var bus_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_nombre)
	value_changed.connect(valor_cambiado)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func valor_cambiado(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
