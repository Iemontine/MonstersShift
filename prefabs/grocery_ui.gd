extends Control

@export var grocery_item_name: String
@onready var buttons = [$Button1, $Button2, $Button3]

func _ready():
	get_parent().visible = false
	for button in buttons:
		button.pressed.connect(self._button_pressed)

func set_grocery_item_name(name: String):
	grocery_item_name = name
	# Logic to update the UI based on the grocery item name

func _button_pressed(button):
	# Logic to handle the selected image option
	PlayerController.unfreeze_player()
	queue_free()
