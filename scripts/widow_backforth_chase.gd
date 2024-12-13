extends Area2D

@export var widow: WidowNPC
@export var player: Player

var attack_mode_active: bool = false
var teleport_distance: float = 200.0
var attack_direction: Vector2 = Vector2.LEFT
var current_teleport_threshold: float = 300.0
var tween: Tween

var glow: PointLight2D

@onready var whispering_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var panner: AudioEffectPanner = AudioEffectPanner.new()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	AudioServer.add_bus_effect(0, panner)

func _process(_delta: float) -> void:
	if attack_mode_active:
		attack()
		adjust_whispering_audio()
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
			tween_panner_pan()
		
		# Check if player is on the wrong side of the widow
		if (attack_direction == Vector2.LEFT and player.global_position.x < widow.global_position.x) or \
		(attack_direction == Vector2.RIGHT and player.global_position.x > widow.global_position.x):
			attack_mode_active = false
			kill_player()

func _on_body_entered(_body: Object) -> void:
	if _body is Player: # TODO, add event check e.g. StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL
		attack_direction = Vector2.LEFT
		NpcController.set_target_npc("NPC_Widow")
		
		widow.set_collision_layer_value(1, false)
		widow.set_collision_mask_value(1, false)
		glow = NpcController.get_target_npc().get_node("Glow")
		widow.activate_glow()

		NpcController.setSpeed(55)

		var whispering = preload("res://assets/assets_widow/015922_whispers-39schizophrenic39-or-ghost-like-voices-56253.mp3")
		whispering_audio.stream = whispering
		add_child(whispering_audio)
		whispering_audio.play()

		MusicManager.play_custom_track("in-the-night-267247.mp3")
		
		tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(widow, "modulate:a", 1, 1).from(0)
		tween.tween_property(glow, "color:a", 1, 1).from(0)
		NpcController.teleport(Vector2(player.global_position.x + attack_direction.x * teleport_distance, self.global_position.y - 20))
		
		PlayerController.control_player()
		PlayerController.stop()
		var camera: Camera2D = get_tree().current_scene.get_node("Camera2D")
		camera.target = widow
		attack()
		await get_tree().create_timer(2).timeout
		attack_mode_active = true
		PlayerController.uncontrol_player()
		player.disable_sprint() # Disable sprinting
		camera.target = player

func _on_body_exited(_body: Object) -> void:
	if _body is Player:
		attack_mode_active = false
		NpcController.stop()
		NpcController.uncontrol_npc()
		
		# TODO: make her fade away
		widow.deactivate_glow()
		
		player.enable_sprint() # Enable sprinting

		panner.pan = 0.0
		whispering_audio.stop()
		MusicManager.stop()

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
	# StoryManager.transition_to_event(StoryManager.Event.WIDOW_NIGHT_SECOND_FAIL)
	PlayerController.start_cutscene("widow_night_second_fail")

func adjust_whispering_audio() -> void:
	var distance = widow.global_position.distance_to(player.global_position)
	var volume = 1.0 - distance / 500.0
	whispering_audio.volume_db = linear_to_db(volume)
	print(whispering_audio.volume_db)

func tween_panner_pan() -> void:
	var target_pan: float
	if attack_direction == Vector2.LEFT:
		target_pan = -0.7
	else:
		target_pan = 0.7
	tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(panner, "pan", target_pan, 1.0)
