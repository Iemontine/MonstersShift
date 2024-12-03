#Global Class: PlayerController
extends Node2D

var player: Player
const Event = preload("res://scripts/story_manager.gd").Event

func _ready() -> void:
	player = get_node_or_null("Player")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if player: player.connect("path_follow_completed", Callable(self, "_on_path_follow_completed"))

func start_cutscene(cutscene_name: String) -> void:
	# TODO: swipe in cool black bars at the top and bottom of the screen
	Dialogic.start(cutscene_name)

func _on_dialogic_signal(argument:String):
	print(argument)
	if argument == "control":
		control_player()
	elif argument == "uncontrol":
		uncontrol_player()

func control_player() -> void:
	player.state = Player.PlayerState.CONTROLLED

func uncontrol_player() -> void:
	player.state = Player.PlayerState.NORMAL

# Possible commands callable by Dialogic are below:
# playAnimation which must be followed by an animationComplete,
# setSpeed, sprint, resetSpeed, moveUp, moveDown, moveLeft, moveRight, stop

func playAnimation(animName: String, direction_x: int = 0, direction_y: int = 0) -> void:
	player.state = Player.PlayerState.LOCKED
	var direction = Vector2(direction_x, direction_y)
	player.travel_to_anim(animName, direction)

# a hacky, but unfortunately functional way to allow the player to continue moving after an animation
func animationComplete() -> void:
	player.state = Player.PlayerState.CONTROLLED
	player.direction = Vector2.ZERO

func switchScene(destination_scene: String, destination_loadzone: String) -> void:
	SceneManager.switch_scene(player, destination_scene, false, destination_loadzone)
	
func advanceStory() -> void:
	StoryManager.advance_story()

func setSpeed(speed: float) -> void:
	player.speed = speed

func sprint() -> void:
	player.speed = player.sprint_multiplier * player.default_speed
	if player.state == Player.PlayerState.CARRYING_ITEM:
		player.movement.movement_anim = "RunCarry"
	else:
		player.movement.movement_anim = "Run"

func resetSpeed() -> void:
	player.speed = player.default_speed
	if player.state == Player.PlayerState.CARRYING_ITEM:
		player.movement.movement_anim = "WalkCarry"
	else:
		player.movement.movement_anim = "Walk"

func moveUp() -> void:
	player.direction = Vector2(0, -1)
	print("Moving up")

func moveDown() -> void:
	player.direction = Vector2(0, 1)
	print("Moving down")

func moveLeft() -> void:
	player.direction = Vector2(-1, 0)
	print("Moving left")

func moveRight() -> void:
	player.direction = Vector2(1, 0)
	print("Moving right")

# TODO: get the player facing in the last direction they moved in instead of assuming left facing when calling stop()
func stop() -> void:
	player.direction = Vector2(0, 0)
	print("Stopping")

func _on_path_follow_completed():
	player.state = Player.PlayerState.NORMAL
	print("Correct!")
