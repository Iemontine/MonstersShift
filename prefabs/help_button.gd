extends Button
@onready var help_labels: Control = $"../../HelpLabels"

func _on_pressed() -> void:
	help_labels.visible = !help_labels.visible
