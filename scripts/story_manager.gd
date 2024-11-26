# StoryManager - Global AutoLoaded Singleton
extends Node

# Implements a linear story, TODO: investigate non-linear story based on player choices? Enum might get ugly in that case.
enum Event { INTRO, ARRIVED_AT_TREEHOUSE_1, ARRIVED_AT_TREEHOUSE_2, END }

@onready var current_event = Event.INTRO

func _ready():
	SceneManager.connect("scene_transition_completed", Callable(self, "_on_scene_transition_completed"))

func transition_to_event(new_event: Event):
	current_event = new_event

func advance_story():
	current_event = current_event + 1 as Event

func _on_scene_transition_completed():
	match current_event:
		Event.INTRO:
			print("intro")
		Event.ARRIVED_AT_TREEHOUSE_1:
			print("arrived at treehouse 1")
		Event.ARRIVED_AT_TREEHOUSE_2:
			print("arrived at treehouse 2")
			PlayerController.start_cutscene("arrived_at_treehouse_2")
		Event.END:
			print("end")
		_:
			print("unknown event")
