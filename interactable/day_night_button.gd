extends Interactable
class_name DayNightButton



func _on_interacted() -> void:
	SceneManager.change_time_of_day()
	super()
