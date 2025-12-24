extends HSlider


func ajustar_brillo(value: float) -> void:
	ColoresPantalla.environment.adjustment_brightness = value
