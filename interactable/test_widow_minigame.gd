extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	start_player_path_follow(player)
	var qte = get_tree().current_scene.get_node("QTE")
	print(get_tree().root.get_tree_string_pretty())
	qte.start_minigame()
	super()

func start_player_path_follow(player):
	player.speed = 50  # Set the speed for the player
	player.path_following = true
	player.state = Player.PlayerState.CONTROLLED
	player.follow_path()
