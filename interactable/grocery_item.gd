extends Interactable
class_name GroceryItem

@export var enabled: bool = false
@onready var exclamation_sprite: Sprite2D = $Exclamation

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
	var grocery_ui: Control = get_parent().get_node("GroceryUI")
	grocery_ui.visible = true
	
	# Start quick time events
	PlayerController.start_quick_time_events()
