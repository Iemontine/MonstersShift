extends Area2D
class_name Chair



enum Direction { UP, DOWN, LEFT, RIGHT }

@export var chair_direction: Direction
var npc: BasicNPC = null  # Keeps track of the NPC that entered the chair area
var occupied:bool = false

var baker:BakerNPC

@onready var chair_sprite: Sprite2D = $Chair


func _ready() -> void:
	baker = get_parent().get_node_or_null("NPC_Baker")

func _on_body_entered(body: Node) -> void:
	# Check if the body that entered is a BasicNPC
	if body is BasicNPC:
		npc = body  # Store a reference to the NPC


func _process(delta: float) -> void:
	if npc and npc.state == BasicNPC.State.ARRIVED:
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
		npc.label.text = npc.want
		npc.label.visible = true
		baker.customer_want.get_or_add(self, npc.want)
	if npc and npc.state == BasicNPC.State.LEAVING:
		npc = null
		


func _on_body_exited(body: Node) -> void:
	# If the NPC leaves the chair area, clear the reference
	if body == npc:
		npc = null
