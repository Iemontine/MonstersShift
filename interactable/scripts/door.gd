extends Interactable
class_name Door


var destination_scene:String
var door_name:String


func _on_interacted() -> void:
	player.frozen = true
	scene_manager.switch_scene(player, destination_scene, false, door_name)
	super()
