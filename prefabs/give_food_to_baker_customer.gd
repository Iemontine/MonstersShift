extends Interactable
@onready var npc_bake_as_customer = $".."
func _on_interacted() -> void:
	if player.carried_item_name == npc_bake_as_customer.want:
		npc_bake_as_customer.state = BakeryCustomerNPC.NPCState.BASIC_LEAVING
