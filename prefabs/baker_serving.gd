extends CharacterBody2D
class_name BakerNPC

enum State{STANDING, NORMAL, HOLDING_ITEM, RETURN,DELIVERING}

const SPEED = 50.0
var state:State

@onready var anim = $SpriteLayers/AnimationPlayer
@onready var animation_tree = $SpriteLayers/AnimationTree
@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var carried_item: Sprite2D = $CarriedItem
@onready var carried_item_name: String = ""
var customer_want = {}

var old_velocity = Vector2.ZERO
var travel_to_position:Vector2
var want:String
	

func _physics_process(delta: float) -> void:
	if state == State.STANDING:
		travel_to_anim("Idle", Vector2(0, 1))
		return
	#var mouse_position = get_global_mouse_position()
	agent_2d.target_position = travel_to_position
	
	
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * SPEED
	old_velocity = new_velocity
	if state == State.NORMAL:
		travel_to_anim("Walk", new_velocity)
	elif state == State.HOLDING_ITEM:
		travel_to_anim("RunCarry", new_velocity)
		for key in customer_want:
			if customer_want[key] == carried_item_name:
				travel_to_position = key.position
				customer_want.erase(key)
	elif state == State.DELIVERING:
		travel_to_anim("RunCarry", new_velocity)
				
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
