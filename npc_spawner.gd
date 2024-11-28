extends Node2D

@export var npc_scene: PackedScene  # NPC scene to spawn
@export var spawn_location: Vector2  # Where to spawn the NPC
@export var target_locations: Array[Vector2] # Array of possible target locations
@onready var marker = $Marker2D
var npc_instance: Node2D = null

func _ready():
	spawn_location = marker.position
	print(marker.position)
	spawn_npc()

# Function to spawn NPC and set it to pathfind to a random location
func spawn_npc():
	# Spawn the NPC at the desired spawn location
	npc_instance = npc_scene.instantiate()
	npc_instance.position = spawn_location
	add_child(npc_instance)
	print(npc_instance.position)


	# Pick a random target location from the array
	if target_locations.size() > 0:
		var random_target = target_locations[randi() % target_locations.size()]
		pathfind_to_target(random_target)

# Function to make the NPC pathfind to the target location
func pathfind_to_target(target: Vector2):
	if npc_instance:
		var navigation_agent = npc_instance.get_node("NavigationAgent2D")
		if navigation_agent:
			# Set the target location for the navigation agent
			navigation_agent.target_position = target
			
			# Start pathfinding by updating the agent every frame
			navigation_agent.set_velocity_forced(Vector2.ZERO)  # Make sure the velocity is reset

# Optional: Update the NPC's movement in _process
func _process(delta: float):
	if npc_instance:
		var navigation_agent = npc_instance.get_node("NavigationAgent2D")
		if navigation_agent:
			# Continuously update the agent's next position
			var next_position = navigation_agent.get_next_path_position()
			
			# Move the NPC towards the next path point
			if next_position != npc_instance.position:
				npc_instance.position = next_position

			# Check if the target is reached or navigation is finished
			if navigation_agent.is_target_reached():
				print("NPC reached the target!")
				return  # Or trigger some event to stop or loop
			elif navigation_agent.is_navigation_finished():
				print("Navigation finished, target unreachable.")
				return  # Handle unreachable target if needed
