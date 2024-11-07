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
		# velocity = input_vector * speed * 2
		velocity = input_vector * speed * 10
	else:
		velocity = input_vector * speed



	animationTree.set("parameters/walk/blend_position", input_vector)


func handle_interaction():
	var direction = last_direction.normalized()
	var position_in_front = global_position + direction * 16  # Assuming tile size is 16x16
	var tilemap_layer = get_parent().get_node("objects")  # Ensure this is a TileMapLayer node
	if tilemap_layer is TileMapLayer:
		var cell = tilemap_layer.local_to_map(position_in_front)
		print(cell)

		#print("Interacted with tile ID: ", tile_id)
	else:
		print("The node 'objects' is not a TileMapLayer")
		

func _physics_process(_delta):
	handle_movement()
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept"):
		handle_interaction()
