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

var _event_name:String = ""

@onready var current_event = Event.INTRO

func _ready():
	SceneManager.connect("scene_transition_completed", Callable(self, "_on_scene_transition_completed"))

func transition_to_event(new_event: Event):
	current_event = new_event

func advance_story():
	current_event = current_event + 1 as Event

func _on_scene_transition_completed():
	match current_event:
		# Event.INTRO:
		# 	_event_name = "intro"
		# Event.ARRIVAL_START_OUTSIDE:
		# 	_event_name = "arrival_start_outside"
		# Event.CLICK_ON_BED:
		# 	_event_name = "click_on_bed"
		# Event.CLICK_ON_PICTURE_FRAME:
		# 	_event_name = "click_on_picture_frame"
		# Event.CLICK_ON_RECORD_PLAYER:
		# 	_event_name = "click_on_record_player"
		# Event.EXIT_HOUSE_POSTARRIVAL:
		# 	_event_name = "exit_house_postarrival"
		Event.OUTSIDE_BAKERY:
			_event_name = "outside_bakery"
			if SceneManager.current_scene == "Bakery":
				_event_name = "first_enter_bakery"
				PlayerController.start_cutscene(_event_name)
		# Event.FIRST_ENTER_BAKERY:
		# 	_event_name = "first_enter_bakery"
		# Event.BAKER_FIRST_INTERACTION:
		# 	_event_name = "baker_first_interaction"
		# Event.BAKER_SUCCESS_DAYTIME:
		# 	_event_name = "baker_success_daytime"
		# Event.BAKER_FAIL_DAYTIME:
		# 	_event_name = "baker_fail_daytime"
		# Event.NIGHT_OUTSIDE_BAKERY:
		# 	_event_name = "night_outside_bakery"
		# Event.BAKER_BEFORE_CHASE:
		# 	_event_name = "baker_before_chase"
		# Event.BAKER_BEFORE_NIGHT_GAME:
		# 	_event_name = "baker_before_night_game"
		# Event.BAKER_SUCCESS_NIGHT:
		# 	_event_name = "baker_success_night"
			_event_name = "baker_fail_night"
		# Event.WIDOW_FIRST_INTERACTION:
		# 	_event_name = "widow_first_interaction"
		# WIDOW
		Event.WIDOW_BEFORE_DAY_GAME:
			if SceneManager.current_scene == "Conbini":
				enable_grocery_items()
			# elif SceneManager.current_scene == "Town":
			# 	PlayerController.start_quick_time_events()
		# Event.WIDOW_BEFORE_DAY_GAME:
		# 	_event_name = "widow_before_day_game"
		# Event.WIDOW_SUCCESS_DAYTIME:
		# 	_event_name = "widow_success_daytime"
		# Event.WIDOW_FAIL_DAYTIME:
		# 	_event_name = "widow_fail_daytime"
		# Event.WIDOW_SUCCESS_NIGHT:
		# 	_event_name = "widow_success_night"
		# Event.WIDOW_FAIL_NIGHT:
		# 	_event_name = "widow_fail_night"
		# Event.END:
		# 	_event_name = "end"
		_:
			print("unknown event")

# WIDOW
func enable_grocery_items():
	var items = get_tree().get_nodes_in_group("grocery_item")
	var enabled_item = items[randi() % items.size()]
	for item in items:
		item.enabled = false
		item.exclamation_sprite.visible = false
	enabled_item.enabled = true
	enabled_item.exclamation_sprite.visible = true
