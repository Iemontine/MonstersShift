extends Interactable


func _on_interacted() -> void:
	var controller: PlayerController = PlayerController.new(player)
	controller.queue_command(Vector2(0,1), 1)
	controller.queue_command(Vector2(1,0), 1)
	controller.queue_command(Vector2(0,-2), 1)
	controller.queue_command(Vector2(-1,0), 1)
	controller.start_dialogue("test", "test_scene_done")
	controller.queue_command(Vector2(-1,0), 1)
	
	add_child(controller)
	print(controller.cmd_list)
	super()
