extends Interactable
class_name GroceryItem

@export var enabled: bool = false
#@onready var exclamation_sprite: Sprite2D = $Exclamation

#func _ready():
	#exclamation_sprite.visible = enabled

func _on_interacted() -> void:
	print("grocery item interaacted")
	if enabled: show_grocery_ui()
	super()

func show_grocery_ui():
	# Logic to show the UI with images
	# Freeze the player
	PlayerController.freeze_player()
	# Show the UI
	var canvas_layer:CanvasLayer = get_parent().get_node("CanvasLayer")
	canvas_layer.visible = true
	var camera: Camera2D = get_viewport().get_camera_2d()
	canvas_layer.transform.origin = camera.global_position
	var canvas_modulate: CanvasModulate = get_parent().get_node("CanvasModulate")
	canvas_modulate.color = Color(0.7, 0.7, 0.7)
	# Start quick time events
	#PlayerController.start_quick_time_events()
