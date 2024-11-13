class_name Player
extends CharacterBody2D


@export var speed = 100
@export var camera: NodePath


@onready var anim = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var interact_box = $InteractBox


var last_direction = Vector2.ZERO
var frozen = false
var enter_scene: bool = false
var walk_to: bool = false
var ignore_loadzone = false


func handle_movement():
	var input_vector = Vector2.ZERO
	
	if walk_to:
		input_vector = last_direction
	elif not frozen:
		if Input.is_action_pressed("up"):
			input_vector.y -= 1
		elif Input.is_action_pressed("down"):
			input_vector.y += 1

		if Input.is_action_pressed("left"):
			input_vector.x -= 1
		elif Input.is_action_pressed("right"):
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
	if frozen and not walk_to:
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
	frozen = true


func _on_unfreeze():
	frozen = false
