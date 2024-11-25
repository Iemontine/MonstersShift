extends Interactable
class_name BakerTrashcan

func _on_interacted() -> void:
	if player.carried_item_name != "":
		trash_item()
		stop_carry()
		print("Item trashed")
	else:
		print("No item to trash")

func trash_item() -> void:
	player.carried_item.texture = null
	player.carried_item.region_enabled = false
	player.carried_item.region_rect = Rect2()

func stop_carry() -> void:
	player.carried_item_name = ""
	player.carried_item.texture = null
	player.carried_item.visible = false
	player.state = Player.PlayerState.NORMAL
