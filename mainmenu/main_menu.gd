extends Node

@export var player:Player
@export var Music : AudioStream = load("res://assets/sound/Lo-fi Music Pack - FREE/Lo-fi Music Pack - FREE/Beach.mp3")

func _ready() -> void:
	var stream = AudioStreamPlayer.new()
	stream.set_stream(Music)
	add_child(stream)
	stream.play()

func _on_start_pressed() -> void:
	StoryManager.transition_to_event(StoryManager.Event.INTRO)
	PlayerController.start_cutscene("intro")

func _on_exitbutton_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://credits/credits.tscn")
