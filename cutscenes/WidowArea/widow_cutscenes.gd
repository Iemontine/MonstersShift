extends Interactable

func _on_interacted() -> void:
	if StoryManager.current_event == StoryManager.Event.DAY_TWO_MORNING:
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_FIRST_INTERACTION)
		PlayerController.start_cutscene("widow_first_interaction")
