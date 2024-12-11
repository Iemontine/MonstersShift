extends Interactable

@export var exclamation_sprite : Sprite2D

#func _ready() -> void:
	#exclamation_sprite.visible = true

func _on_interacted() -> void:
	if StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL:
		StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_RECORD_PLAYER)
		
		if StoryManager.objects_interacted_with >= 2:
			StoryManager.transition_to_event(StoryManager.Event.READY_TO_EXIT)
		else:
			StoryManager.objects_interacted_with += 1
		
		PlayerController.start_cutscene("click_on_record_player")
		#exclamation_sprite.visible = false
		queue_free()
