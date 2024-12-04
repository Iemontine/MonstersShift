extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	StoryManager.transition_to_event(Event.ARRIVAL_START_OUTSIDE)
	PlayerController.start_cutscene("arrived_at_treehouse_1")
	super()
