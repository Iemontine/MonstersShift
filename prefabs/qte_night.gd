extends QTE_Day
class_name QTE_Night

@export var widow:WidowNPC

func _ready() -> void:
	super()
	lives = 3
	perfect_speed = 125
	normal_speed = 100
	normal_anim = "Run"
	perfect_anim = "Run"

func _physics_process(delta: float) -> void:
	super(delta)
	if minigame_active and qte_active:
		# Widow attacks
		var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP]
		var attack_direction = directions[randi() % directions.size()]
		if widow.state != NPC.NPCState.WIDOW_ATTACKING and widow.state != NPC.NPCState.CONTROLLED:
			widow.attack(attack_direction)
		player.travel_to_anim("Evade", attack_direction)

func _handle_qte_result(result_type: String, speed: float, anim: String, should_lose_life: bool = false):
	super(result_type, speed, anim, should_lose_life)
	if widow.state == widow.NPCState.WIDOW_ATTACKING:
		widow.backoff()

func start_minigame():
	lives = 3
	minigame_active = true
	time_passed = 0.0
	visible = true
	minigame_timer.start()
	if player:
		set_player_speed(normal_speed)
		set_player_movement_anim(normal_anim)
		player.path_following = true
		player.state = Player.PlayerState.CONTROLLED
		player.follow_path()

func _on_minigame_timer_timeout():
	if minigame_active:
		time_passed += 1
		print("Minigame time: ", time_passed, " seconds , Number of lives: ", lives)
		if int(time_passed) % 3 == 0 and time_passed > 6:
			print("QTE event triggered at ", time_passed, " seconds")
			reset()
			set_player_speed(0)
			emit_signal("QTE_starts")
			qte_timer.start()
		else:
			minigame_timer.start()

func fail_player():
	# KILL PLAYER!!!!!!!!!!!gRAAAAAAAAAAAAAAAA
	player.path_following = false
	player.state = Player.PlayerState.LOCKED
	player.travel_to_anim("DeathBounce")
	stop_minigame()
	# StoryManager.transition_to_event(StoryManager.Event.WIDOW_FAIL_NIGHT)
	PlayerController.start_cutscene("widow_fail_night")

func _on_path_follow_completed():
	var wall: StaticBody2D = get_tree().current_scene.get_node_or_null("WidowWall")
	if wall:
		wall.set_collision_layer_value(1, true)
		wall.set_collision_mask_value(1, true)

	stop_minigame()
	StoryManager.transition_to_event(StoryManager.Event.WIDOW_NIGHT_QTE_SUCCESS)
