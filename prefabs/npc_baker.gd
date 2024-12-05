extends NPC
class_name BakerNPC

@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var carried_item: Sprite2D = $CarriedItem
@onready var carried_item_name: String = ""
@onready var chat_bubble: AnimatedSprite2D = $ChatBubble

var customer_want = {}

signal point_earned

var player:Player
var old_velocity = Vector2.ZERO
var travel_to_position:Vector2
var want:String
var player_in_area:bool = false
var spawn_location:Vector2
var current_chair_target: Chair

func _ready() -> void:
	state = NPCState.BAKER_IDLE
	travel_to_position = global_position
	spawn_location = travel_to_position
	super._ready()

func _physics_process(_delta: float) -> void:
	if state == NPCState.CONTROLLED:
		return
	agent_2d.target_position = travel_to_position
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * 50
	old_velocity = new_velocity
	
	match state:
		NPCState.BAKER_IDLE:
			travel_to_anim("Idle", Vector2(0,1))
			if player_in_area and Input.is_action_pressed("ui_accept"):
				on_interacted()
		NPCState.BAKER_HOLDING_ITEM:
			travel_to_anim("WalkCarry", old_velocity)
			for key in customer_want:
				if customer_want[key] == carried_item_name:
					print(key)
					current_chair_target = key
					travel_to_position = key.global_position
					customer_want.erase(key)
					state = NPCState.BAKER_DELIVERING
					break
		NPCState.BAKER_DELIVERING:
			travel_to_anim("WalkCarry", old_velocity)
			if agent_2d.is_navigation_finished():
				point_earned.emit()
				carried_item_name = ""
				state = NPCState.BAKER_RETURNING
				travel_to_position = spawn_location
				#make NPC return to door
				current_chair_target.npc.state = NPCState.BASIC_LEAVING
				customer_want.erase(current_chair_target)
		NPCState.BAKER_RETURNING:
			if agent_2d.is_navigation_finished():
				state = NPCState.BAKER_IDLE
	
	if agent_2d.is_navigation_finished():
		return
		
	if agent_2d.avoidance_enabled:
		agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	super._physics_process(_delta)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func on_interacted() -> void:
	if (player.carried_item_name == "Garbage"):
		chat_bubble.play("mad")
	elif player.carried_item_name == "":
		chat_bubble.play("question")
		
		return
	if _contains_string_in_dict(player.carried_item_name, customer_want):
		add_child(player.carried_item)
		state = NPCState.BAKER_HOLDING_ITEM
		carried_item_name = player.carried_item_name
		player.carried_item_name = ""
		player.state = Player.PlayerState.NORMAL
	else:
		# TODO: this is bad because it continues to fire if the player holds the interact button
		# (involving the usage of signals from the Area2Ds)
		print("no one wants that")

func _on_area_2d_body_entered(body: Player) -> void:
	player = body
	player_in_area = true

func _on_area_2d_body_exited(_body: Player) -> void:
	player_in_area = false

func _contains_string_in_dict(target_string: String, dictionary: Dictionary) -> bool:
	for value in dictionary.values():
		if target_string in value:
			return true
	return false
