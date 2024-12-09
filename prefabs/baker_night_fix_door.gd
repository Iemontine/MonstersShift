extends Interactable
@export var repair_damage:float = 20
@onready var progress_bar: ProgressBar = $"../ProgressBar"

func _on_interacted() -> void:
	if player.carried_item_name == "Wood":
		progress_bar.value = min(progress_bar.max_value,progress_bar.value + repair_damage)
		player.carried_item_name = ""
	super()
