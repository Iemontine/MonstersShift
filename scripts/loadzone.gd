extends Area2D
class_name loadzone

@export var target_scene: String
@export var target_loadzone_name: String
@onready var player = get_node("/root/Player")

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

# Called when a body enters the loadzone
func _on_body_entered(body: Node) -> void:
	if body == player:
		# Disable player input
		player.set_process_input(false)
		# Move player towards the loadzone direction
		_move_player_to_loadzone()
		# Start scene transition
		_transition_to_scene()

# Move player towards the loadzone direction
func _move_player_to_loadzone() -> void:
	# implement logic to move player towards the loadzone direction
	# could involve setting the player's velocity or position
	pass

# Handle scene transition
func _transition_to_scene() -> void:
	# Implement fade to black effect
	# Change to the target scene
	get_tree().change_scene_to_file(target_scene)
	# Ensure the player is placed at the corresponding loadzone in the new scene
	place_player_at_target_loadzone()

# Place player at the corresponding loadzone in the new scene
func place_player_at_target_loadzone() -> void:
	# Find the target loadzone in the new scene
	var target_loadzone = get_node("/root/CurrentScene/" + target_loadzone_name)
	if target_loadzone:
		player.global_position = target_loadzone.global_position
		# Re-enable player input
		player.set_process_input(true)