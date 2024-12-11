extends Interactable

@export var exclamation_sprite : Sprite2D

#func _ready() -> void:
	#exclamation_sprite.visible = true

func _on_interacted() -> void:
	if StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL:
		StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_RECORD_PLAYER)
		PlayerController.start_cutscene("click_on_record_player")
		#exclamation_sprite.visible = false
		queue_free()
