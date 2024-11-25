class_name Loadzone
extends Area2D


@export var destination_scene: String
@export var should_player_walk:bool = true
@export var destination_loadzone: String = "Loadzone"


func _on_body_entered(player) -> void:
	if player is Player and player.state != Player.PlayerState.CONTROLLED:
		player.state = Player.PlayerState.LOCKED
		if should_player_walk:
			player.state = Player.PlayerState.CONTROLLED
		scene_manager.switch_scene(player, destination_scene, player.state == Player.PlayerState.CONTROLLED, destination_loadzone)
