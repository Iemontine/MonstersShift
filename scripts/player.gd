class_name Player
extends CharacterBody2D

@export var speed = 100
@export var camera: NodePath

@onready var anim = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var interact_box = $InteractBox

var last_direction = Vector2.ZERO
var is_frozen = false

func handle_movement():
	if is_frozen:
		return
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

	if Input.is_key_pressed(KEY_SHIFT):
		velocity = input_vector * speed * 10
	else:
		velocity = input_vector * speed
	
	if input_vector != Vector2.ZERO:
		last_direction = input_vector

		# Update InteractBox position based on last direction
		if last_direction == Vector2.UP:
			interact_box.position = Vector2(0, -32)
		elif last_direction == Vector2.DOWN:
			interact_box.position = Vector2(0, 28)
		elif last_direction == Vector2.LEFT:
			interact_box.position = Vector2(-24, -2)
		elif last_direction == Vector2.RIGHT:
			interact_box.position = Vector2(24, -2)

	animationTree.set("parameters/walk/blend_position", input_vector)

func handle_interaction():
	if is_frozen:
		return
		
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = interact_box.shape
	query.transform = interact_box.global_transform
	query.collision_mask = collision_layer

	var result = space_state.intersect_shape(query)
	for collision in result:
		var collider = collision.collider
		if collider is Interactable:
			collider.interact()

func _physics_process(_delta):
	handle_movement()
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept"):
		handle_interaction()

func _on_freeze():
	print("frozen!")
	is_frozen = true

func _on_unfreeze():
	print("unfrozen	!")
	is_frozen = false
