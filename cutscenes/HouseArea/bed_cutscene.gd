extends Interactable

func _on_interacted() -> void:
	print("interacted")
	if StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL:
		StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_BED)
		PlayerController.start_cutscene("click_on_bed")
		queue_free()
