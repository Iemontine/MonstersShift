extends CharacterBody2D
class_name BakerNPC

enum State{IDLE, HOLDING_ITEM, DELIVERING, RETURNING}

const SPEED = 50.0
var state:State

@onready var anim = $SpriteLayers/AnimationPlayer
@onready var animation_tree = $SpriteLayers/AnimationTree
@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var carried_item: Sprite2D = $CarriedItem
@onready var carried_item_name: String = ""
var customer_want = {}

var player:Player
var old_velocity = Vector2.ZERO
var travel_to_position:Vector2
var want:String
var player_in_area:bool = false
var spawn_location:Vector2
var current_chair_target: Chair

func _ready() -> void:
	state = State.IDLE
	travel_to_position = global_position
	spawn_location = travel_to_position

func _physics_process(delta: float) -> void:
	
	agent_2d.target_position = travel_to_position
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * SPEED
	old_velocity = new_velocity
	if state == State.IDLE:
		travel_to_anim("Idle", Vector2(0,1))
		if player_in_area and Input.is_action_pressed("ui_accept"):
			on_interacted()
			pass
	elif state == State.HOLDING_ITEM:
		travel_to_anim("RunCarry", velocity)
		for key in customer_want:
			if customer_want[key] == carried_item_name:
				print(key)
				current_chair_target = key
				travel_to_position = key.global_position
				customer_want.erase(key)
				state = State.DELIVERING
				break
	elif state == State.DELIVERING:
		if agent_2d.is_navigation_finished():
			carried_item_name = ""
			state = State.RETURNING
			travel_to_position = spawn_location
			#make NPC return to door
			current_chair_target.npc.state = BasicNPC.State.LEAVING
			customer_want.erase(current_chair_target)
			print(current_chair_target)
	elif state == State.RETURNING:
		if agent_2d.is_navigation_finished():
			state = State.IDLE
	

	if agent_2d.is_navigation_finished():
		return
		
	if agent_2d.avoidance_enabled:
		agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()

func travel_to_anim(animName:String, direction = null):
	if direction != null: old_velocity = direction

	animation_tree.set("parameters/"+animName+"/blend_position", direction)
	animation_state.travel(animName)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func on_interacted() -> void:
	if contains_string_in_dict(player.carried_item_name, customer_want):
		#baker get item
		add_child(player.carried_item)
		state = BakerNPC.State.HOLDING_ITEM
		carried_item_name = player.carried_item_name
		
		#player give item
		player.carried_item_name = ""
		player.state = Player.PlayerState.NORMAL
		
	else:
		# TODO: this is bad because it continues to fire if the player holds the interact button
		# (involving the usage of signals from the Area2Ds)
		print("no want want that")

func _on_area_2d_body_entered(body: Player) -> void:
	player = body
	player_in_area = true

func _on_area_2d_body_exited(body: Player) -> void:
	player_in_area = false

func contains_string_in_dict(target_string: String, dictionary: Dictionary) -> bool:
	for value in dictionary.values():
		if target_string in value:
			return true
	return false
