extends Interactable

func _on_interacted() -> void:
	if StoryManager.current_event == StoryManager.Event.DAY_TWO_MORNING:
		StoryManager.transition_to_event(StoryManager.Event.DAY_TWO_MORNING)
		PlayerController.start_cutscene("day_two_morning")
