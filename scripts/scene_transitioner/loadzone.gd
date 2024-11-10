class_name SceneSwitcher
extends Area2D


@export var destination_scene: String
@export var should_player_walk:bool = true
var target: Player


func _on_body_entered(player: Player) -> void:
	if player is Player and not player.ignore_scene_switcher:
		player.frozen = true
		if should_player_walk:
			player.walk_to = true
		player.ignore_scene_switcher = true
		scene_manager.switch_scene(player, destination_scene, player.walk_to)
