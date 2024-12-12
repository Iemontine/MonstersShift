# StoryManager - Global AutoLoaded Singleton
extends Node

# Implements a linear story, TODO: investigate non-linear story based on player choices? Enum might get ugly in that case.
enum Event {
	INTRO,
	ARRIVAL_START_OUTSIDE, CLICK_ON_BED, CLICK_ON_PICTURE_FRAME,
	CLICK_ON_RECORD_PLAYER, LEAVE_TOO_EARLY, READY_TO_EXIT, EXIT_HOUSE_POSTARRIVAL,
	OUTSIDE_BAKERY, FIRST_ENTER_BAKERY, BAKER_FIRST_INTERACTION, BAKER_SUCCESS_DAYTIME,
	BAKER_FAIL_DAYTIME, LEAVING_BAKERY_EVENING, BAKER_PLAYER_INSOMNIA,
	NIGHT_OUTSIDE_BAKERY, BAKER_BEFORE_CHASE, BAKER_BEFORE_NIGHT_GAME,
	BAKER_SUCCESS_NIGHT, BAKER_FAIL_NIGHT, DAY_TWO_MORNING, BAKER_DAY_TWO,
	WIDOW_FIRST_INTERACTION, WIDOW_BEFORE_DAY_GAME, WIDOW_DAY_GAME_CORRECT, WIDOW_DAY_GAME_WRONG,
	WIDOW_DAY_QTE_SUCCESS, WIDOW_DAY_QTE_FAIL, WIDOW_SUCCESS_DAYTIME, WIDOW_FAIL_DAYTIME,
	WIDOW_PLAYER_INSOMNIA, NIGHT_ENTER_CONBINI, WIDOWS_HOUSE_NIGHT,
	WIDOW_NIGHT_QTE_SUCCESS, WIDOW_NIGHT_QTE_FAIL, WIDOW_NIGHT_SECOND_FAIL,
	WIDOW_SUCCESS_NIGHT, WIDOW_FAIL_NIGHT,
	LAST_MORNING, FINAL_SCENES, END
}

var check_for_bed = false
var objects_interacted_with : int = 0

# var _event_name:String = ""

@onready var current_event = Event.WIDOWS_HOUSE_NIGHT

func _ready():
	SceneManager.connect("scene_transition_completed", Callable(self, "_on_scene_transition_completed"))

func transition_to_event(new_event: Event):
	current_event = new_event

func advance_story():
	current_event = current_event + 1 as Event

func _on_scene_transition_completed():
	print(current_event)
	match current_event:
		# Event.INTRO:
		# 	_event_name = "intro"
		# Event.ARRIVAL_START_OUTSIDE:
		# 	_event_name = "arrival_start_outside"
		Event.CLICK_ON_BED:
			# _event_name = "click_on_bed"
			if SceneManager.current_scene == "Treehouse_Exterior":
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene("exit_house_postarrival")
		Event.CLICK_ON_PICTURE_FRAME:
			# _event_name = "click_on_picture_frame"
			if SceneManager.current_scene == "Treehouse_Exterior":
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene("exit_house_postarrival")
		Event.CLICK_ON_RECORD_PLAYER:
			# _event_name = "click_on_record_player"
			if SceneManager.current_scene == "Treehouse_Exterior":
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene("exit_house_postarrival")
		Event.READY_TO_EXIT:
			# _event_name = "ready_to_exit"
			if SceneManager.current_scene == "Treehouse_Exterior":
				# _event_name = 
				StoryManager.transition_to_event(StoryManager.Event.EXIT_HOUSE_POSTARRIVAL)
				PlayerController.start_cutscene("exit_house_postarrival")
		
		Event.OUTSIDE_BAKERY:
			# _event_name = "outside_bakery"
			if SceneManager.current_scene == "Bakery_No_Game":
				# _event_name = "first_enter_bakery"
				StoryManager.transition_to_event(StoryManager.Event.FIRST_ENTER_BAKERY)
				PlayerController.start_cutscene("baker_success_daytime_game")
		Event.BAKER_SUCCESS_DAYTIME:
			if SceneManager.current_scene == "Town":
				StoryManager.transition_to_event(StoryManager.Event.LEAVING_BAKERY_EVENING)
				PlayerController.start_cutscene("leaving_bakery_evening")
		Event.LEAVING_BAKERY_EVENING:
			if SceneManager.current_scene == "Treehouse_Interior":
				StoryManager.transition_to_event(StoryManager.Event.BAKER_PLAYER_INSOMNIA)
				PlayerController.start_cutscene("baker_player_insomnia")
		Event.NIGHT_OUTSIDE_BAKERY:
			# _event_name = "night_outside_bakery"
			if SceneManager.current_scene == "Bakery_No_Game":
				StoryManager.transition_to_event(StoryManager.Event.BAKER_BEFORE_CHASE)
				PlayerController.start_cutscene("baker_before_chase")
		Event.BAKER_BEFORE_CHASE:
			if SceneManager.current_scene == "Treehouse_Interior":
				StoryManager.transition_to_event(StoryManager.Event.BAKER_BEFORE_NIGHT_GAME)
				PlayerController.start_cutscene("baker_before_night_game")
		Event.BAKER_SUCCESS_NIGHT:
			if SceneManager.current_scene == "Treehouse_Interior":
				StoryManager.transition_to_event(StoryManager.Event.DAY_TWO_MORNING)
				PlayerController.start_cutscene("day_two_morning")
				
		Event.DAY_TWO_MORNING:
			if SceneManager.current_scene == "Town":
				NpcController.set_target_npc("NPC_Widow")
				NpcController.set_npc_position(-1200.0, -499.0)
		Event.WIDOW_BEFORE_DAY_GAME:
			if SceneManager.current_scene == "Conbini":
				enable_grocery_items()
				SceneManager.change_time_of_day(-1)
		Event.WIDOW_DAY_QTE_FAIL:
			if SceneManager.current_scene == "Conbini":
				enable_grocery_items()
			if SceneManager.current_scene == "Town":
				start_player_path_follow(SceneManager.dest_player)
				var qte = get_tree().current_scene.get_node("QTE")
				qte.start_minigame()
		Event.WIDOW_FAIL_DAYTIME:
			if SceneManager.current_scene == "Conbini":
				enable_grocery_items()
			if SceneManager.current_scene == "Town":
				start_player_path_follow(SceneManager.dest_player)
				var qte = get_tree().current_scene.get_node("QTE")
				qte.start_minigame()
		Event.WIDOW_DAY_QTE_SUCCESS:
			if SceneManager.current_scene == "Town":
				start_player_path_follow(SceneManager.dest_player)
				var qte = get_tree().current_scene.get_node("QTE")
				qte.start_minigame()
		Event.WIDOW_SUCCESS_DAYTIME:
			if SceneManager.current_scene == "Treehouse_Interior":
				StoryManager.transition_to_event(StoryManager.Event.WIDOW_PLAYER_INSOMNIA)
				PlayerController.start_cutscene("widow_player_insomnia")
		Event.WIDOW_PLAYER_INSOMNIA:
			if SceneManager.current_scene == "Conbini":
				StoryManager.conbini_night()
				StoryManager.transition_to_event(StoryManager.Event.NIGHT_ENTER_CONBINI)
				PlayerController.start_cutscene("night_enter_conbini")
		Event.NIGHT_ENTER_CONBINI:
			if SceneManager.current_scene == "Town":
				StoryManager.transition_to_event(StoryManager.Event.WIDOWS_HOUSE_NIGHT)
				PlayerController.start_cutscene("widows_house_night")
		Event.LAST_MORNING:
			if SceneManager.current_scene == "Treehouse_Exterior":
				StoryManager.transition_to_event(StoryManager.Event.FINAL_SCENES)
				PlayerController.start_cutscene("final_scenes")

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
			

func conbini_night():
	get_tree().current_scene.get_node("Lights").enable_flickering_light()

# WIDOW
func enable_grocery_items():
	if SceneManager.current_scene == "Conbini":
		get_tree().current_scene.get_node("GroceryHandler").enable_grocery_items()


func start_player_path_follow(player):
	player.speed = 50  # Set the speed for the player
	player.path_following = true
	player.state = Player.PlayerState.CONTROLLED
	player.follow_path()
