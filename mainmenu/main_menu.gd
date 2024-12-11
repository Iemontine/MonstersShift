extends Node


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://map/map_dev_kat.tscn")


func _on_button_2_pressed() -> void:
	pass # optional button 2 function


func _on_exitbutton_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://CREDITS/GodotCredits.tscn")
