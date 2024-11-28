extends Interactable

@onready var baker = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interacted() -> void:
	
	if true: #contains_string_in_dict(player.carried_item_name, baker.customer_want):
		#baker get item
		baker.carried_item = player.carried_item
		baker.carried_item_name = player.carried_item_name
		baker.state = BakerNPC.State.HOLDING_ITEM
		
		#player give item
		player.carried_item = null
		player.carried_item_name = ""
		player.state = Player.PlayerState.NORMAL
		
	else:
		print("no want want that")
func contains_string_in_dict(target_string: String, dictionary: Dictionary) -> bool:
	for value in dictionary.values():
		if target_string in value:
			return true
	return false
