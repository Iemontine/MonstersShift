extends InteractableArea2D

@onready var baker = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interacted() -> void:
	
	if true: #contains_string_in_dict(player.carried_item_name, baker.customer_want):
		#baker get item
		add_child(player.carried_item)
		baker.state = BakerNPC.State.HOLDING_ITEM
		baker.carried_item_name = player.carried_item_name
		
		#player give item
		player.carried_item_name = ""
		player.state = Player.PlayerState.NORMAL
		
	else:
		print("no want want that")
func contains_string_in_dict(target_string: String, dictionary: Dictionary) -> bool:
	for value in dictionary.values():
		if target_string in value:
			return true
	return false
