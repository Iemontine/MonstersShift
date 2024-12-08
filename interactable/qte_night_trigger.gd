extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player: # TODO, add event check e.g. StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL
		#StoryManager.transition_to_event(StoryManager.Event.LEAVE_TOO_EARLY)
		#PlayerController.start_cutscene("leave_early_postarrival")
		#queue_free()
