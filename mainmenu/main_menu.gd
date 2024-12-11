extends Node

@export var player:Player

func _on_start_pressed() -> void:
	StoryManager.transition_to_event(StoryManager.Event.INTRO)
	PlayerController.start_cutscene("intro")


func _on_button_2_pressed() -> void:
	pass # optional button 2 function


func _on_exitbutton_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://CREDITS/GodotCredits.tscn")
