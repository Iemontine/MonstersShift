extends Interactable

func _on_interacted() -> void:
	PlayerController.start_cutscene()
	super()
