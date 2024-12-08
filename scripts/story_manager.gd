# StoryManager - Global AutoLoaded Singleton
extends Node

# Implements a linear story, TODO: investigate non-linear story based on player choices? Enum might get ugly in that case.
enum Event { 
	INTRO, 
	ARRIVAL_START_OUTSIDE, CLICK_ON_BED, CLICK_ON_PICTURE_FRAME,
	CLICK_ON_RECORD_PLAYER, READY_TO_EXIT, EXIT_HOUSE_POSTARRIVAL, LEAVE_TOO_EARLY,
	OUTSIDE_BAKERY, FIRST_ENTER_BAKERY, BAKER_FIRST_INTERACTION, BAKER_SUCCESS_DAYTIME, 
	BAKER_FAIL_DAYTIME, LEAVING_BAKERY_EVENING, BAKER_PLAYER_INSOMNIA,
	NIGHT_OUTSIDE_BAKERY, BAKER_BEFORE_CHASE, BAKER_BEFORE_NIGHT_GAME, 
	BAKER_SUCCESS_NIGHT, BAKER_FAIL_NIGHT, DAY_TWO_MORNING,
	WIDOW_FIRST_INTERACTION, WIDOW_BEFORE_DAY_GAME, WIDOW_DAY_GAME_CORRECT, WIDOW_DAY_GAME_WRONG, 
	WIDOW_SUCCESS_DAYTIME, WIDOW_DAY_QTE_SUCCESS, WIDOW_FAIL_DAYTIME, WIDOW_PLAYER_INSOMNIA,
	WIDOW_SUCCESS_NIGHT, WIDOW_FAIL_NIGHT,
	END 
}

var check_for_bed = false
var objects_interacted_with : int = 0

var _event_name:String = ""

@onready var current_event = Event.NIGHT_OUTSIDE_BAKERY

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
		Event.CLICK_ON_BED:
			_event_name = "click_on_bed"
			if SceneManager.current_scene == "Treehouse_Exterior":
				_event_name = "exit_house_postarrival"
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene(_event_name)
		Event.CLICK_ON_PICTURE_FRAME:
			_event_name = "click_on_picture_frame"
			if SceneManager.current_scene == "Treehouse_Exterior":
				_event_name = "exit_house_postarrival"
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene(_event_name)
		Event.CLICK_ON_RECORD_PLAYER:
			_event_name = "click_on_record_player"
			if SceneManager.current_scene == "Treehouse_Exterior":
				_event_name = "exit_house_postarrival"
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene(_event_name)
		Event.READY_TO_EXIT:
			_event_name = "ready_to_exit"
			if SceneManager.current_scene == "Treehouse_Exterior":
				_event_name = "exit_house_postarrival"
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene(_event_name)
		
		Event.OUTSIDE_BAKERY:
			_event_name = "outside_bakery"
			if SceneManager.current_scene == "Bakery_No_Game":
				_event_name = "first_enter_bakery"
				StoryManager.transition_to_event(StoryManager.Event.FIRST_ENTER_BAKERY)
				PlayerController.start_cutscene(_event_name)
		Event.BAKER_SUCCESS_DAYTIME:
			_event_name = "baker_success_daytime_game"
			if SceneManager.current_scene == "Town":
				_event_name = "leaving_bakery_evening"
				StoryManager.transition_to_event(StoryManager.Event.LEAVING_BAKERY_EVENING)
				PlayerController.start_cutscene(_event_name)
		Event.LEAVING_BAKERY_EVENING:
			if SceneManager.current_scene == "Treehouse_Interior":
				_event_name = "baker_player_insomnia"
				StoryManager.transition_to_event(StoryManager.Event.BAKER_PLAYER_INSOMNIA)
				PlayerController.start_cutscene(_event_name)
		Event.NIGHT_OUTSIDE_BAKERY:
			_event_name = "night_outside_bakery"
			if SceneManager.current_scene == "Bakery_No_Game":
				_event_name = "baker_before_chase"
				StoryManager.transition_to_event(StoryManager.Event.BAKER_BEFORE_CHASE)
				PlayerController.start_cutscene(_event_name)
		Event.BAKER_BEFORE_CHASE:
			if SceneManager.current_scene == "Treehouse_Interior":
				_event_name = "baker_before_night_game"
				StoryManager.transition_to_event(StoryManager.Event.BAKER_BEFORE_NIGHT_GAME)
				PlayerController.start_cutscene(_event_name)
		
		Event.WIDOW_BEFORE_DAY_GAME:
			if SceneManager.current_scene == "Conbini":
				enable_grocery_items()
		Event.WIDOW_DAY_GAME_CORRECT:
			if SceneManager.current_scene == "Town":
				var player = PlayerController.player

				start_player_path_follow(player)
		Event.WIDOW_SUCCESS_DAYTIME:
			if SceneManager.current_scene == "Treehouse_Interior":
				_event_name = "widow_player_insomnia"
				StoryManager.transition_to_event(StoryManager.Event.WIDOW_PLAYER_INSOMNIA)
				PlayerController.start_cutscene(_event_name)


		# Event.WIDOW_DAY_GAME_WRONG:

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
	#var enabled_item = items[randi() % items.size()]
	#for item in items:
		#item.enabled = false
		#item.exclamation_sprite.visible = false
	#enabled_item.enabled = true
	#enabled_item.exclamation_sprite.visible = true

func start_player_path_follow(player):
	player.speed = 50  # Set the speed for the player
	player.path_following = true
	player.state = Player.PlayerState.CONTROLLED
	player.follow_path()
