extends Area2D


const Event = preload("res://scripts/story_manager.gd").Event


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player and StoryManager.current_event > StoryManager.Event.NIGHT_ENTER_CONBINI: # TODO, add event check e.g. StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL
		var qte = get_tree().current_scene.get_node("QTE")
		print(get_tree().root.get_tree_string_pretty())
		qte.start_minigame()
