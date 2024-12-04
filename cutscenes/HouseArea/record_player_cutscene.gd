extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player:
		StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_RECORD_PLAYER)
		PlayerController.start_cutscene("click_on_record_player")
		queue_free()
