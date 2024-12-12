extends Interactable

func _on_interacted() -> void:
	print("helllo?")
	var parent = get_parent()
	if parent is BakerNPC and parent.has_method("on_interacted"):
		parent.on_interacted()
