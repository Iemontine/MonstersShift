class_name Loadzone
extends Area2D


@export var destination_scene: String
@export var should_player_walk:bool = true
@export var destination_loadzone: String = "Loadzone"
var target: Player


func _on_body_entered(player: Player) -> void:
	if player is Player and player.state != Player.PlayerState.WALK_TO:
		player.state = Player.PlayerState.FROZEN
		if should_player_walk:
			player.state = Player.PlayerState.WALK_TO
		scene_manager.switch_scene(player, destination_scene, player.state == Player.PlayerState.WALK_TO, destination_loadzone)
