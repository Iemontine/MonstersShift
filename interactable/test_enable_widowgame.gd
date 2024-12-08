extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	print("here")
	#StoryManager.transition_to_event(StoryManager.Event.WIDOW_DAY_QTE_SUCCESS)
	StoryManager.transition_to_event(StoryManager.Event.WIDOW_DAY_QTE_FAIL)
	super()
