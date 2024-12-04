extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if (
		_body is Player 
		and (StoryManager.current_event == StoryManager.Event.INTRO 
		or StoryManager.current_event == StoryManager.Event.LEAVE_TOO_EARLY)
	):
		StoryManager.transition_to_event(StoryManager.Event.ARRIVAL_START_OUTSIDE)
		PlayerController.start_cutscene("arrival_start_outside")
		queue_free()
