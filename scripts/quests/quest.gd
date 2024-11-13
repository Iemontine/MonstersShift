extends Node
class_name Quest

var reward : int = 0
var finished : bool

func _process(_delta: float) -> void:
	pass

# override when making an actual quest
func get_quest_name() -> String:
	return "null quest"

# unsure of what type this should be
func get_rewards() -> int:
	return reward;

func done() -> bool:
	return finished
