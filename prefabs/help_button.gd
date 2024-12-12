extends Button
@onready var help_labels: Control = $"../../HelpLabels"
@onready var baker_game_logic: CanvasLayer = $".."
@export var is_night:bool

func _on_pressed() -> void:
	if !is_night:
		PlayerController.start_cutscene("how_to_play")
	else:
		PlayerController.start_cutscene("night_how_to_play")
	
	
	
