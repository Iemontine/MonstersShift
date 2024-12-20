extends Area2D


const Event = preload("res://scripts/story_manager.gd").Event


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player:
		if (StoryManager.current_event > StoryManager.Event.NIGHT_ENTER_CONBINI
				and StoryManager.current_event < StoryManager.Event.LAST_MORNING
		):
			SceneManager.change_time_of_day(SceneManager.TIME.NIGHT)
			
			NpcController.set_target_npc("NPC_Widow")
			NpcController.control_npc()
			NpcController.setSpeed(150)
			NpcController.teleport(Vector2(396,-50))
			NpcController.setMovementAnim("Hug")
			NpcController.moveRight()
			
			PlayerController.control_player()
			PlayerController.stop()

			var scream_sound = preload("res://assets/assets_widow/scream-90747.mp3")
			var scream_player = AudioStreamPlayer.new()
			scream_player.stream = scream_sound
			add_child(scream_player)
			scream_player.play()
			
			# Play the specified track using MusicManager
			MusicManager.play_custom_track("Distorted_Signal__BGM_DOVA-SYNDROME_OFFICIAL_YouTube_CHANNEL.mp3")

			var widow : WidowNPC = NpcController.get_target_npc()
			var glow = widow.get_node("Glow")
			var camera: Camera2D = get_tree().current_scene.get_node("Camera2D")
			var player: Player = _body
			
			widow.activate_glow()

			camera.target = widow
			
			await get_tree().create_timer(1.25).timeout
			
			var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(widow, "modulate:a", 0, 1).from(1)
			tween.tween_property(glow, "color:a", 0, 1).from(1)
			NpcController.setMovementAnim("Walk")
			PlayerController.uncontrol_player()
			NpcController.uncontrol_npc()
			camera.target = player

			var qte = get_tree().current_scene.get_node("QTE")
			qte.start_minigame()


func _on_player_path_follow_completed() -> void:
	MusicManager.stop()
