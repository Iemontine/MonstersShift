extends Interactable

func _on_interacted() -> void:
	if StoryManager.current_event == StoryManager.Event.WIDOW_FIRST_INTERACTION:
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_BEFORE_DAY_GAME)
		PlayerController.start_cutscene("widow_before_day_game")