class_name Player
extends CharacterBody2D


@onready var animationPlayer = $SpriteLayers/AnimationPlayer
@onready var animationTree = $SpriteLayers/AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var interact_box = $InteractBox
@onready var textbox:TextureRect = $TextBox
@onready var default_speed = speed



const ACCELERATION = 10
const FRICTION = 10


@export var speed = 50
@export var sprint_multiplier = 10
@export var camera: NodePath
var last_direction = Vector2.ZERO
var frozen = false
var enter_scene: bool = false
var walk_to: bool = false
var ignore_loadzone = false
var cutscene_walk: bool = false
var cutscene_walk_direction: Vector2

# TODO: refactor this, all these booleans/flags is bad style. frozen and walk_to can potentially be replaced with unbinding the input map
# and further logic. cutscene_walk and cutscene_walk_direction could leverage the current state of binding the input map and last_direction
# respectively

func _ready():
	animationTree.set_animation_player(animationPlayer.get_path())
	animationTree.active = true
	speed = default_speed


func travel_to_anim(animName:String, direction = null):
	if direction != null: last_direction = direction

	animationTree.set("parameters/"+animName+"/blend_position", last_direction)
	#if animName.begins_with("Walk"):
		#animationTree.advance(get_physics_process_delta_time() * 0.001)
	animationState.travel(animName)


func move_interact_box():
	var direction = last_direction
	var box_position = interact_box.position

	if direction == Vector2.UP: box_position = Vector2(0, -17)
	elif direction == Vector2.DOWN: box_position = Vector2(0, 17)
	elif direction == Vector2.LEFT: box_position = Vector2(-19, -13.25)
	elif direction == Vector2.RIGHT: box_position = Vector2(19, -13.25)

	interact_box.position = box_position


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
	move_and_slide()
	move_interact_box()
	
	if Input.is_action_just_pressed("ui_accept"):
		handle_interaction()

	if Input.is_key_pressed(KEY_SHIFT):
		speed = sprint_multiplier * default_speed
		$Movement.movement_anim = "Run"
	else:
		speed = default_speed
		$Movement.movement_anim = "Walk"

func _on_freeze():
	frozen = true


func _on_unfreeze():
	frozen = false
