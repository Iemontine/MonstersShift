extends Interactable

func _on_interacted() -> void:
	StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_PICTURE_FRAME)
	PlayerController.start_cutscene("click_on_picture_frame")
	queue_free()
