extends Node2D

@export_range(0,200) var flicker := 500
var noise = FastNoiseLite.new()
var value := 0.0

func _process(delta):
	value += flicker*delta
	$PointLight2D.energy = (noise.get_noise_1d(value) + 1/4.0) + 5.0
