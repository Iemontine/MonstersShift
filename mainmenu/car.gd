extends Node2D 

@export var movement_range: float = 10.0  # Maximum distance the car can move left/right
@export var movement_speed: float = 1.0  # Speed of the horizontal movement

var initial_x: float = 0.0  # The car's starting x-position
var target_x_offset: float = 0.0  # The target x offset

func _ready() -> void:
	# Store the car's starting x-position
	initial_x = position.x
	# Set an initial random target offset within the range
	target_x_offset = randf_range(-movement_range, movement_range)

func _process(delta: float) -> void:
	# Calculate the target position relative to the initial position
	var target_x = initial_x + target_x_offset

	# Smoothly move towards the target position
	position.x = lerp(position.x, target_x, delta * movement_speed)

	# If the car is close to the target, pick a new random target offset
	if abs(position.x - target_x) < 0.5:
		target_x_offset = randf_range(-movement_range, movement_range)
