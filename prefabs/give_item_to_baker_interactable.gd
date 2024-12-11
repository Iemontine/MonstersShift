extends Interactable
@onready var npc_baker: BakerNPC = $"../NPC_Baker"

func _on_interacted() -> void:
	print(interacted)
	npc_baker.on_interacted()
