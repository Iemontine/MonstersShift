extends Interactable

const Event = preload("res://scripts/story_manager.gd").Event

func _on_interacted() -> void:
	player.speed = 50  # Set the speed for the player
	player.path_following = true
	player.state = Player.PlayerState.CONTROLLED
	player.follow_path()
	super()
