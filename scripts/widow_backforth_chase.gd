extends Area2D

@export var widow: WidowNPC
@export var player: Player

var attack_mode_active: bool = false
var teleport_distance: float = 200.0
var attack_direction: Vector2 = Vector2.LEFT
var current_teleport_threshold: float = 300.0
var tween: Tween

var glow:PointLight2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if attack_mode_active:
		attack()
		#print(current_teleport_threshold)
		if widow.global_position.distance_to(player.global_position) > current_teleport_threshold:
			attack_direction = -attack_direction
			match attack_direction:
				Vector2.LEFT:
					current_teleport_threshold = randf_range(300, 400)
				Vector2.RIGHT:
					current_teleport_threshold = randf_range(220, 300)
			tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(widow, "modulate:a", 0, 1).from(1)
			tween.tween_property(glow, "color:a", 0, 1).from(1)
			NpcController.teleport(Vector2(player.global_position.x + attack_direction.x * teleport_distance, self.global_position.y - 20))
			tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(widow, "modulate:a", 1, 1).from(0)
			tween.tween_property(glow, "color:a", 1, 1).from(0)
		
		# Check if player is on the wrong side of the widow
		if (attack_direction == Vector2.LEFT and player.global_position.x < widow.global_position.x) or \
		(attack_direction == Vector2.RIGHT and player.global_position.x > widow.global_position.x):
			kill_player()
			attack_mode_active = false

func _on_body_entered(_body: Object) -> void:
	if _body is Player: # TODO, add event check e.g. StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL
		attack_direction = Vector2.LEFT
		NpcController.set_target_npc("NPC_Widow")
		
		glow = NpcController.get_target_npc().get_node("Glow")
		glow.visible = true

		NpcController.setSpeed(50)
		
		tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(widow, "modulate:a", 1, 1).from(0)
		tween.tween_property(glow, "color:a", 1, 1).from(0)
		NpcController.teleport(Vector2(player.global_position.x + attack_direction.x * teleport_distance, self.global_position.y - 20))
		
		player.disable_sprint() # Disable sprinting
		PlayerController.control_player()
		PlayerController.stop()
		var camera: Camera2D = get_tree().current_scene.get_node("Camera2D")
		camera.target = widow
		attack()
		await get_tree().create_timer(2).timeout
		attack_mode_active = true
		PlayerController.uncontrol_player()
		camera.target = player

func _on_body_exited(_body: Object) -> void:
	if _body is Player:
		attack_mode_active = false
		NpcController.stop()
		NpcController.uncontrol_npc()
		widow.deactivate_glow()
		
		player.enable_sprint() # Enable sprinting

func attack() -> void:
	if attack_direction == Vector2.LEFT:
		NpcController.moveRight()
	else:
		NpcController.moveLeft()

func kill_player():
	NpcController.stop()
	NpcController.uncontrol_npc()
	widow.attack(-attack_direction)
	player.state = Player.PlayerState.LOCKED
	player.travel_to_anim("DeathBounce")
	# StoryManager.transition_to_event(StoryManager.Event.WIDOW_FAIL_NIGHT)
	# PlayerController.start_cutscene("widow_fail_night")
