extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	StoryManager.transition_to_event(Event.ARRIVED_AT_TREEHOUSE_1)
	PlayerController.start_cutscene("arrived_at_treehouse_1")
	super()
