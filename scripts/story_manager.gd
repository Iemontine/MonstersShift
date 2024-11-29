# StoryManager - Global AutoLoaded Singleton
extends Node

# Implements a linear story, TODO: investigate non-linear story based on player choices? Enum might get ugly in that case.
enum Event { 
	INTRO, 
	ARRIVAL_START_OUTSIDE, CLICK_ON_BED, CLICK_ON_PICTURE_FRAME,
	CLICK_ON_RECORD_PLAYER, EXIT_HOUSE_POSTARRIVAL,
	OUTSIDE_BAKERY, FIRST_ENTER_BAKERY, BAKER_FIRST_INTERACTION, BAKER_SUCCESS_DAYTIME, 
	BAKER_FAIL_DAYTIME, NIGHT_OUTSIDE_BAKERY, BAKER_BEFORE_CHASE, 
	BAKER_BEFORE_NIGHT_GAME, BAKER_SUCCESS_NIGHT, BAKER_FAIL_NIGHT,
	WIDOW_FIRST_INTERACTION, WIDOW_BEFORE_DAY_GAME, WIDOW_SUCCESS_DAYTIME,
	WIDOW_FAIL_DAYTIME, WIDOW_SUCCESS_NIGHT, WIDOW_FAIL_NIGHT,
	END 
}

var _event_name:String

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
			_event_name = "intro"
		Event.ARRIVAL_START_OUTSIDE:
			_event_name = "arrival start outside"
		Event.END:
			_event_name = "end"
		_:
			print("unknown event")
	
	print(_event_name)
	PlayerController.start_cutscene(_event_name)
