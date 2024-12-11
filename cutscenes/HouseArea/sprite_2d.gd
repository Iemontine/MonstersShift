extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if StoryManager.current_event != StoryManager.Event.READY_TO_EXIT:
		#visible = false
	pass
