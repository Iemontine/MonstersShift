class_name Player
extends CharacterBody2D

@export var speed = 100
@export var camera: NodePath


@onready var anim = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")


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

	if Input.is_key_pressed(KEY_SHIFT):
		velocity = input_vector * speed * 2
	else:
		velocity = input_vector * speed


	animationTree.set("parameters/walk/blend_position", input_vector)


func _physics_process(delta):
	handle_movement()
	move_and_slide()
