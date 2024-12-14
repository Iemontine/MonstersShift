extends Node

@export var noise:Noise = null
@export var enabled:bool = false

var time_passed = 0.0

func _process(delta: float) -> void:
	if not enabled: return

	time_passed += delta * 12

	for child in get_children():
		if child is PointLight2D:
			if child.get_index() == 0 or child.get_index() == 6:
				var offset = child.get_index() * 100.0
				var noise_value = noise.get_noise_1d(time_passed + offset)
				child.energy = abs(noise_value) * 1.2

func enable_flickering_light() -> void:
	get_node("../PointLight2D").energy = 1.02
	get_node("../PointLight2D").visible = true

	get_tree().current_scene.get_node_or_null("CanvasModulate").color = Color(0.121, 0.173, 0.367)
	enabled = true
	for child in get_children():
		if child is PointLight2D:
			child.energy = randf_range(0.1,0.2)
			child.visible = true
