extends Button
@onready var help_labels: Control = $"../../HelpLabels"
@onready var baker_game_logic: CanvasLayer = $".."

func _on_pressed() -> void:
	PlayerController.start_cutscene("how_to_play")
	
