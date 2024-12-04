extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player and StoryManager.current_event == StoryManager.Event.EXIT_HOUSE_POSTARRIVAL:
		StoryManager.transition_to_event(StoryManager.Event.OUTSIDE_BAKERY)
		PlayerController.start_cutscene("outside_bakery")
		queue_free()
