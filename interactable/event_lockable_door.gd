extends Door
class_name EventLockableDoor

@export var after_event : StoryManager.Event = StoryManager.Event.READY_TO_EXIT
@export var before_event : StoryManager.Event = StoryManager.Event.READY_TO_EXIT
@export var scene : String

func _on_interacted() -> void:
	var current_event = StoryManager.current_event
	if current_event >= before_event or current_event < after_event:
		super()
	else:
		PlayerController.start_cutscene(scene)
	
	pass
