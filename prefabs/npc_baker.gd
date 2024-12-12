extends NPC
class_name BakerNPC

@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var carried_item: Sprite2D = $CarriedItem
@onready var carried_item_name: String = ""
#@onready var chat_bubble: AnimatedSprite2D = $ChatBubble

var customer_want = {}

signal point_earned

var old_velocity = Vector2.ZERO
var travel_to_position: Vector2
var spawn_location: Vector2
var current_chair_target: Chair

func _ready() -> void:
	state = NPCState.BAKER_IDLE
	travel_to_position = global_position
	spawn_location = travel_to_position
	carried_item.visible = false
	super._ready()

func _physics_process(_delta: float) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED:
		super._physics_process(_delta)
		return
	
	update_navigation()
	handle_state()
	super._physics_process(_delta)

func update_navigation() -> void:
	agent_2d.target_position = travel_to_position
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * 50
	old_velocity = new_velocity
	
	if agent_2d.is_navigation_finished():
		return
	
	if agent_2d.avoidance_enabled:
		agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

func handle_state() -> void:
	match state:
		NPCState.BAKER_IDLE:
			handle_idle_state()
		NPCState.BAKER_HOLDING_ITEM:
			handle_holding_item_state()
		NPCState.BAKER_DELIVERING:
			handle_delivering_state()
		NPCState.BAKER_RETURNING:
			handle_returning_state()

func handle_idle_state() -> void:
	travel_to_anim("Idle", Vector2(0, -1))

func handle_holding_item_state() -> void:
	travel_to_anim("WalkCarry", old_velocity)
	carried_item.visible = true
	for key in customer_want:
		if customer_want[key] == carried_item_name:
			current_chair_target = key
			customer_want.erase(key)
			travel_to_anim("PickupCarry", Vector2(0, 1))
			$NavigationAgent2D.target_desired_distance = 25
			travel_to_position = current_chair_target.global_position
			state = NPCState.BAKER_DELIVERING
			break

func handle_delivering_state() -> void:
	travel_to_anim("WalkCarry", old_velocity)
	if agent_2d.is_navigation_finished():
		point_earned.emit()
		carried_item_name = ""
		state = NPCState.BAKER_RETURNING
		travel_to_position = spawn_location
		current_chair_target.npc.state = NPCState.BASIC_LEAVING
		customer_want.erase(current_chair_target)

func handle_returning_state() -> void:
	$NavigationAgent2D.target_desired_distance = 1
	travel_to_anim("Walk", old_velocity)
	carried_item.visible = false
	if agent_2d.is_navigation_finished():
		state = NPCState.BAKER_IDLE

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED:
		return
	velocity = safe_velocity

func on_interacted() -> void:
	var player: Player = $InteractionBox.player
	if _contains_string_in_dict(player.carried_item_name, customer_want):
		state = NPCState.BAKER_HOLDING_ITEM
		carried_item.texture = player.carried_item.texture
		carried_item.region_enabled = true
		carried_item.region_rect = player.carried_item.region_rect
		carried_item_name = player.carried_item_name
		player.carried_item_name = ""
		player.state = Player.PlayerState.NORMAL
	else:
		print("no one wants that")

func _contains_string_in_dict(target_string: String, dictionary: Dictionary) -> bool:
	for value in dictionary.values():
		if target_string in value:
			return true
	return false
