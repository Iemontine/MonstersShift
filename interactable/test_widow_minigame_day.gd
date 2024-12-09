extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	var qte = get_tree().current_scene.get_node("QTE")
	print(get_tree().root.get_tree_string_pretty())
	qte.start_minigame()
	super()
