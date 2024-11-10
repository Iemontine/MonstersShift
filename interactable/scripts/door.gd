extends Interactable
class_name Door


var destination_scene:String


func _on_interacted() -> void:
	player.frozen = true
	scene_manager.switch_scene(player, destination_scene, false)
	super()
