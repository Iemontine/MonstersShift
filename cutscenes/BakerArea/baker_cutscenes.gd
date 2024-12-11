extends Interactable

func _on_interacted() -> void:
	if StoryManager.current_event == StoryManager.Event.FIRST_ENTER_BAKERY:
		StoryManager.transition_to_event(StoryManager.Event.BAKER_FIRST_INTERACTION)
		PlayerController.start_cutscene("baker_first_interaction")
	if StoryManager.current_event >= StoryManager.Event.DAY_TWO_MORNING:
		PlayerController.start_cutscene("baker_day_two")
