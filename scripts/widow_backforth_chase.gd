extends Area2D

@export var widow: WidowNPC
@export var player: Player

var attack_mode_active: bool = false
var teleport_distance: float = 200.0
var attack_direction: Vector2 = Vector2.LEFT
var current_teleport_threshold: float = 300.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if attack_mode_active:
		attack()
		print(current_teleport_threshold)
		if widow.global_position.distance_to(player.global_position) > current_teleport_threshold:
			attack_direction = -attack_direction
			match attack_direction:
				Vector2.LEFT:
					current_teleport_threshold = randf_range(300, 400)
				Vector2.RIGHT:
					current_teleport_threshold = randf_range(220, 300)
			NpcController.teleport(Vector2(player.global_position.x + attack_direction.x * teleport_distance, self.global_position.y))

func _on_body_entered(_body: Object) -> void:
	if _body is Player: # TODO, add event check e.g. StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL
		NpcController.set_target_npc("NPC_Widow")
		NpcController.setSpeed(50)
		NpcController.teleport(Vector2(player.global_position.x + attack_direction.x * teleport_distance, self.global_position.y))
		NpcController.get_target_npc().modulate.a = 1
		
		attack_mode_active = true
		player.disable_sprint() # Disable sprinting
		PlayerController.control_player()
		PlayerController.stop()
		var camera: Camera2D = get_tree().current_scene.get_node("Camera2D")
		camera.target = widow
		await get_tree().create_timer(2).timeout
		PlayerController.uncontrol_player()
		camera.target = player

func _on_body_exited(_body: Object) -> void:
	if _body is Player:
		attack_mode_active = false
		player.enable_sprint() # Enable sprinting

func attack() -> void:
	if attack_direction == Vector2.LEFT:
		NpcController.moveRight()
	else:
		NpcController.moveLeft()

# func start_attack_mode():
# 	while attack_mode_active:
		
		
		
		
# 		# if widow.global_position.distance_to(player.global_position) > teleport_distance:
# 		# 	print("Widow is far from player, teleporting")
# 		# 	teleport_widow()
# 		# else:
# 		# 	print("Widow is close to player, moving towards player")
# 		# 	move_widow_towards_player()
# 		# await get_tree().create_timer(0.5).timeout

# func move_widow_towards_player():
# 	var direction = (player.global_position - widow.global_position).normalized()
# 	if direction.x > 0:
# 		print("Moving widow to the right")
# 		widow.move(Vector2.RIGHT)
# 	else:
# 		print("Moving widow to the left")
# 		widow.move(Vector2.LEFT)

# func teleport_widow():
# 	var target_position = player.global_position + Vector2(attack_distance, 0)
# 	print("Teleporting widow to position: ", target_position)
# 	widow.global_position = target_position

# func kill_player():
# 	print("Player touched the widow, killing player")
# 	player.state = Player.PlayerState.LOCKED
# 	player.travel_to_anim("Death")
#	StoryManager.transition_to_event(StoryManager.Event.WIDOW_FAIL_NIGHT)
#	PlayerController.start_cutscene("widow_fail_night")
