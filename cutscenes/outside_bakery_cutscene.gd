extends Area2D

#const Event = preload("res://scripts/story_manager.gd").Event


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player:
		StoryManager.transition_to_event(StoryManager.Event.OUTSIDE_BAKERY)
		PlayerController.start_cutscene("outside_bakery")
		queue_free()
