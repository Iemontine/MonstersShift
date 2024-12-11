extends Sprite2D

#@export var exclamation_sprite: Sprite2D

func _ready() -> void:
	visible = true
	print(StoryManager.current_event)
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if StoryManager.current_event > StoryManager.Event.READY_TO_EXIT:
		visible = false
	if StoryManager.objects_interacted_with >= 3:
		visible = false
	pass
