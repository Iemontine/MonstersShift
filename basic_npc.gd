extends CharacterBody2D
class_name BasicNPC

enum State{PATH_FINDING, ARRIVED}

const SPEED = 50.0
var state:State

@onready var anim = $SpriteLayers/AnimationPlayer
@onready var animation_tree = $SpriteLayers/AnimationTree
@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var label: Label = $Label

var food: Array[String] = ["Cake", "Cookie", "Brownie"]

var old_velocity = Vector2.ZERO
var travel_to_position:Vector2
var want:String

func _ready() -> void:
	want = food.pick_random()
	label.text = want
	label.visible = false
	

func _physics_process(delta: float) -> void:
	if state == State.ARRIVED:
		#travel_to_anim("SitChair")
		return
	#var mouse_position = get_global_mouse_position()
	agent_2d.target_position = travel_to_position
	
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * SPEED
	old_velocity = new_velocity
	if state == State.PATH_FINDING:
		travel_to_anim("Walk", new_velocity)
		
	if agent_2d.is_navigation_finished():
		state = State.ARRIVED
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
