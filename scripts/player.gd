class_name Player
extends CharacterBody3D

@export var speed = 1.7
@export var camera: NodePath
@onready var anim = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

var can_interact: bool = false
var last_direction = Vector2.ZERO

func handle_movement():
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	elif Input.is_action_pressed("ui_down"):
		input_vector.y += 1

	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	elif Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	input_vector = input_vector.normalized()
	
	# Apply some inertia for a slippery effect
	var target_velocity = Vector3(input_vector.x * speed, 0, input_vector.y * speed)
	
	# Adjust movement direction relative to camera
	var camera_node = get_node(camera)
	if camera_node:
		var camera_forward = camera_node.global_transform.basis.z  # Invert the forward vector
		var camera_right = camera_node.global_transform.basis.x
		var direction = (camera_right * target_velocity.x + camera_forward * target_velocity.z).normalized()
		
		velocity = velocity.lerp(Vector3(direction.x, 0, direction.z) * speed, 0.1)  # Adjust the factor for more or less slipperiness
		
		print(input_vector)

		if input_vector != Vector2.ZERO:
			animationTree.set("parameters/Walk/blend_position", input_vector)
			animationState.travel("Walk")
			last_direction = input_vector
		else:
			animationTree.set("parameters/Idle/blend_position", last_direction)
			animationState.travel("Idle")
		
		# Rotate player to face the camera
		look_at(camera_node.global_transform.origin, Vector3.UP)
	else:
		print("Camera node not found")

func _physics_process(delta):
	handle_movement()
	move_and_slide()
