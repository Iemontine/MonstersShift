extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	StoryManager.transition_to_event(StoryManager.Event.WIDOW_BEFORE_DAY_GAME)
	super()
