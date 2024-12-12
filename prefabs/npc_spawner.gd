extends Node2D
class_name NPCSpawner


@export var npc_scene: PackedScene 
@export var spawn_location:Vector2
@export var travel_locations: Array[Chair]
@export var max_npcs: int = 3
@export var spawn_interval: float = 8.0
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D


var npc_instances: Array = []
var spawn_timer: Timer
var total_spawned: int = 0


func _ready():
	
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "on_timer_completed"))
	add_child(spawn_timer)
	spawn_timer.start()

	# Initialize all chairs as unoccupied
	for chair in travel_locations:
		chair.occupied = false  # Ensure all chairs start as unoccupied

func on_timer_completed():
	if total_spawned < max_npcs:
		spawn_npc()

func spawn_npc():
	total_spawned += 1
	animation_player.play("door_open")
	# Spawn NPC
	var npc_instance = npc_scene.instantiate()
	npc_instance.position = spawn_location
	npc_instance.spawner = self
	add_child(npc_instance)
	npc_instances.append(npc_instance)

	# Pick a random available travel location
	var travel_location = get_random_available_travel_location()
	npc_instance.chair = travel_location
	if travel_location != null:
		npc_instance.travel_to_position = travel_location.global_position
		travel_location.occupied = true  # Mark the chair as occupied
		print(travel_location)

func get_random_available_travel_location() -> Chair:
	# Filter out chairs that are already occupied
	var available_locations = []
	for chair in travel_locations:
		if not chair.occupied:
			available_locations.append(chair)
	
	# If no locations are available, return null
	if available_locations.size() == 0:
		return null
	
	# Pick a random chair from the available ones
	return available_locations[randi() % available_locations.size()]
