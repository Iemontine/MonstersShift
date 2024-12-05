extends NPC
class_name BakeryCustomerNPC

@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var want_label = $WantLabel

var food: Array[String] = ["Cake", "Cookie", "Brownie"]


var old_velocity = Vector2.ZERO
var travel_to_position:Vector2
var want:String
var spawner:NPCSpawner
var chair:Chair

func _ready() -> void:
	state = NPCState.BASIC_PATH_FINDING
	want = food.pick_random()
	want_label.text = want
	want_label.visible = false

func _physics_process(_delta: float) -> void:
	if state == NPCState.CONTROLLED:
		return
	if state == NPCState.BASIC_DESTROY:
		print("destroy")
		spawner.npc_instances.erase(self)
		queue_free()
	agent_2d.target_position = travel_to_position
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	match state:
		NPCState.BASIC_PATH_FINDING:
			travel_to_anim("Walk", new_velocity)
			if agent_2d.is_navigation_finished():
				state = NPCState.BASIC_ARRIVED
		NPCState.BASIC_LEAVING:
			travel_to_anim("Walk", new_velocity)
			travel_to_position = spawner.global_position
			agent_2d.target_position = travel_to_position
			if agent_2d.is_navigation_finished():
				spawner.animation_player.play_backwards("double door open")
				chair.occupied = false
				visible = false
				spawner.npc_instances.erase(self)
				queue_free()
				state = NPCState.BASIC_DESTROY
	
	if agent_2d.avoidance_enabled:
		agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

	super._physics_process(_delta)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity