extends Interactable
class_name Door


@export var destination_scene:String
@export var target_door:String


func _on_interacted() -> void:
	player.frozen = true
	scene_manager.switch_scene(player, destination_scene, false, target_door)
	super()
