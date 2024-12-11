extends Interactable

func _on_interacted() -> void:
	if StoryManager.current_event == StoryManager.Event.WIDOW_FIRST_INTERACTION:
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_BEFORE_DAY_GAME)
		PlayerController.start_cutscene("widow_before_day_game")
	super()

func _on_player_path_follow_completed() -> void:
	if StoryManager.current_event == StoryManager.Event.WIDOW_DAY_QTE_SUCCESS:
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_SUCCESS_DAYTIME)
		PlayerController.start_cutscene("widow_success_daytime")
	elif StoryManager.current_event == StoryManager.Event.WIDOW_DAY_QTE_FAIL:
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_FAIL_DAYTIME)
		PlayerController.start_cutscene("widow_fail_daytime")
