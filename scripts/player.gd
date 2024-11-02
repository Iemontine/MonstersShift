class_name Player
extends CharacterBody3D

@export var speed = 1.7
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
	velocity = velocity.lerp(target_velocity, 0.1)  # Adjust the factor for more or less slipperiness
	
	print(input_vector)

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		last_direction = input_vector
	else:
		animationTree.set("parameters/Idle/blend_position", last_direction)
		animationState.travel("Idle")

func _physics_process(delta):
	handle_movement()
	move_and_slide()

#
#func _on_InteractBox_body_entered(body):
	#if body.is_in_group("Dialog"):
		#can_interact = true
#func _on_InteractBox_body_exited(body):
	#if body.is_in_group("Dialog"):
		#can_interact = false
