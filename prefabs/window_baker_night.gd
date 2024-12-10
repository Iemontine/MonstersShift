extends Interactable

@onready var npc_baker_night: BakerNPCNight = $"../NPC_Baker_Night"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_interacted() -> void:
	print("interacted with window")
	if player.carried_item_name == npc_baker_night.baker_want:
		npc_baker_night.food_at_window = true
		player.travel_to_anim("ThrowCarry", Vector2(0,1))
		player.carried_item_name = ""
	elif player.carried_item_name != npc_baker_night.baker_want and player.carried_item_name != "":
		Dialogic.start("BakerDontWantThis")
	else:
		PlayerController.start_cutscene("BakerWindowNoItem")
		print("Thats not what the baker wanted")
		pass
