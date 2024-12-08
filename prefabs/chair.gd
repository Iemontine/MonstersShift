extends Area2D
class_name Chair

enum Direction { UP, DOWN, LEFT, RIGHT }

@export var chair_direction: Direction
var npc: BakeryCustomerNPC = null  # Keeps track of the NPC that entered the chair area
var occupied:bool = false

var baker:BakerNPC

func _ready() -> void:
	baker = get_parent().get_node_or_null("NPC_Baker")

func _on_body_entered(body: Node) -> void:
	# Check if the body that entered is a NPCBakeryCustomer
	if body is BakeryCustomerNPC:
		print("npc set in chair")
		npc = body  # Store a reference to the NPC


func _process(_delta: float) -> void:
	if npc != null and npc.state == NPC.NPCState.BASIC_ARRIVED:
		npc.travel_to_anim("SitChair")

		# Adjust position and animation based on chair direction
		match chair_direction:
			Direction.UP:
				npc.travel_to_anim("SitChair", Vector2(0, -1))
				npc.global_position = global_position + Vector2(0, -2)
			Direction.DOWN:
				npc.travel_to_anim("SitChair", Vector2(0, 1))
				npc.global_position = global_position + Vector2(0, 2)
			Direction.LEFT:
				npc.travel_to_anim("SitChair", Vector2(-1, 0))
				npc.global_position = global_position + Vector2(-3, 2)
			Direction.RIGHT:
				npc.travel_to_anim("SitChair", Vector2(1, 0))
				npc.global_position = global_position + Vector2(3, 2)
		npc.want_label.text = npc.want
		npc.want_label.visible = true
		baker.customer_want.get_or_add(self, npc.want)
		
func _on_body_exited(body: Node) -> void:
	# If the NPC leaves the chair area, clear the reference
	if body == npc:
		pass
		#npc = null
