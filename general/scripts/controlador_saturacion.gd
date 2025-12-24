extends HSlider


func ajustar_saturacion(value: float) -> void:
	ColoresPantalla.environment.adjustment_saturation = value
