extends Interactable
class_name Door


@export var destination_scene:String
@export var target_door:String


func _on_interacted() -> void:
	player.state = Player.PlayerState.LOCKED
	player.velocity = Vector2.ZERO
	player.travel_to_anim("Idle")
	#$AnimatedSprite2D.play()
	SceneManager.switch_scene(player, destination_scene, false, target_door)
	super()
