class_name SceneSwitcher
extends Area2D


@export var destination_scene: String
var target: Player


func _on_body_entered(player: Node2D) -> void:
	if player is Player and !player.ignore_scene_switcher:
		player.frozen = true
		player.walk_to = true
		player.ignore_scene_switcher = true
		scene_manager.switch_scene(player, destination_scene)
