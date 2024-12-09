extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event
var attack_directions = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT]
var current_attack_index = 0
var interaction_count = 0

func _on_interacted() -> void:
	var widow = get_tree().current_scene.get_node("NPC_Widow")
	if widow:
		if interaction_count % 2 == 0:
			widow.attack(attack_directions[current_attack_index])
			current_attack_index = (current_attack_index + 1) % attack_directions.size()
		else:
			widow.backoff()
		interaction_count += 1
	super()
