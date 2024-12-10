extends Interactable

func _on_interacted() -> void:
	if StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL:
		StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_RECORD_PLAYER)
		
		if StoryManager.objects_interacted_with >= 2:
			StoryManager.transition_to_event(StoryManager.Event.READY_TO_EXIT)
		else:
			StoryManager.objects_interacted_with += 1
		
		PlayerController.start_cutscene("click_on_record_player")
		queue_free()
