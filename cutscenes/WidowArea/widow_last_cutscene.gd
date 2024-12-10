extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player:
		if StoryManager.current_event == StoryManager.Event.WIDOW_NIGHT_QTE_SUCCESS:
			StoryManager.transition_to_event(StoryManager.Event.WIDOW_SUCCESS_NIGHT)
			PlayerController.start_cutscene("widow_success_night")
		else:
			StoryManager.transition_to_event(StoryManager.Event.LAST_MORNING)
			PlayerController.start_cutscene("last_morning")
	