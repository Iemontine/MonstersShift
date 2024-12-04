extends Interactable

func _on_interacted() -> void:
	StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_BED)
	PlayerController.start_cutscene("click_on_bed")
	queue_free()
