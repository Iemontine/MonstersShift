extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	var qte = get_tree().current_scene.get_node("QTE")
	qte.start_minigame()
	super()
