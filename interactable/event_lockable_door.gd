extends Door
class_name EventLockableDoor

@export var event : StoryManager.Event = StoryManager.Event.READY_TO_EXIT
@export var scene : String

func _on_interacted() -> void:
	if StoryManager.current_event >= event:
		super()
	else:
		PlayerController.start_cutscene(dialogue)
	
	pass
