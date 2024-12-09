extends Area2D


const Event = preload("res://scripts/story_manager.gd").Event


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player: # TODO, add event check e.g. StoryManager.current_event < StoryManager.Event.EXIT_HOUSE_POSTARRIVAL
		
		
		NpcController.set_target_npc("NPC_Widow")
		NpcController.control_npc()
		NpcController.setSpeed(150)
		NpcController.teleport(Vector2(396,-50))
		NpcController.setMovementAnim("Hug")
		NpcController.moveRight()
		
		PlayerController.control_player()
		PlayerController.stop()
		
		var widow : WidowNPC = NpcController.get_target_npc()
		var camera: Camera2D = get_tree().current_scene.get_node("Camera2D")
		var player: Player = _body
		
		widow.activate_eyes()

		camera.target = widow
		
		await get_tree().create_timer(1).timeout
		
		var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(widow, "modulate:a", 0, 0.5).from(1)
		NpcController.setMovementAnim("Walk")
		PlayerController.uncontrol_player()
		NpcController.uncontrol_npc()
		camera.target = player

		var qte = get_tree().current_scene.get_node("QTE")
		print(get_tree().root.get_tree_string_pretty())
		qte.start_minigame()
