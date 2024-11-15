extends Node2D

var player : Player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("body entered")
		player = body
		var controller: PlayerController = PlayerController.new(player)
		controller.command(Vector2(0,1), 1)
		controller.command(Vector2(1,0), 1)
		controller.command(Vector2(0,-2), 1)
		controller.command(Vector2(-1,0), 1)
		controller.start_dialogue("test", "test_scene_done")
		controller.command(Vector2(-1,0), 1)
		
		add_child(controller)
		print(controller.cmd_list)
