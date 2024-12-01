extends Area2D

const Event = preload("res://scripts/story_manager.gd").Event


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Player) -> void:
	StoryManager.transition_to_event(Event.OUTSIDE_BAKERY)
	queue_free()
