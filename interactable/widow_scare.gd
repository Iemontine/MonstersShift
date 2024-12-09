extends Area2D

@onready var widow:WidowNPC = get_tree().current_scene.get_node_or_null("NPC_Widow")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(_body:Object) -> void:
	if _body is Player: # TODO add event check and StoryManager.current_event == StoryManager.Event.DAY_TWO_MORNING:
		NpcController.set_target_npc("NPC_Widow")
		print(widow.modulate.a)
		widow.modulate.a = 1
		widow.visible = true
		print(widow.modulate.a)
		NpcController.control_npc()
		NpcController.teleport(Vector2(912,-328))
		NpcController.setSpeed(50)
		NpcController.moveDown()

		await get_tree().create_timer(3.0).timeout

		NpcController.stop()
		var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(widow, "modulate:a", 0, 0.5).from(1)
		NpcController.uncontrol_npc()
		
		#StoryManager.transition_to_event(StoryManager.Event.WIDOW_FIRST_INTERACTION)
		#PlayerController.start_cutscene("widow_first_interaction")
