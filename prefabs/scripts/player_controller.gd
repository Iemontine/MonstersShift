#Global Class: PlayerController
extends Node2D

var player: Player

func _ready() -> void:
	player = get_node_or_null("Player")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func start_cutscene() -> void:
	# TODO: swipe in cool black bars at the top and bottom of the screen
	Dialogic.start("cutscene")

func _on_dialogic_signal(argument:String):
	print(argument)
	if argument == "control":
		player.state = Player.PlayerState.CONTROLLED
	elif argument == "uncontrol":
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

func stop() -> void:
	player.direction = Vector2(0, 0)
	print("Stopping")
