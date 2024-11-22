class_name Player
extends CharacterBody2D


enum PlayerState { NORMAL, FROZEN, WALK_TO, CUTSCENE_WALK, CARRYING_ITEM }
const CLICK_THRESHOLD = 1.0


@onready var animationPlayer = $SpriteLayers/AnimationPlayer
@onready var animationTree = $SpriteLayers/AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var interact_box = $InteractBox
@onready var default_speed = speed
@onready var movement = $Movement
@onready var carried_item: Sprite2D = $CarriedItem


@export var speed = 50
@export var sprint_multiplier = 2
@export var camera: NodePath


var last_direction = Vector2.ZERO
var state = PlayerState.NORMAL
var cutscene_walk_direction: Vector2


var hold_start_time = 0.0
var is_holding = false
var current_interactable = null


func _ready():
	animationTree.set_animation_player(animationPlayer.get_path())
	animationTree.active = true
	speed = default_speed


func travel_to_anim(animName:String, direction = null):
	# print(animName)
	if direction != null: last_direction = direction
	animationTree.set("parameters/"+animName+"/blend_position", last_direction)
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
	if (state == PlayerState.FROZEN and not is_holding) or state == PlayerState.WALK_TO:
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
	if state == PlayerState.FROZEN and not is_holding: return
	
	move_and_slide()
	move_interact_box()

	if state == PlayerState.WALK_TO: return

	# Set the speed and walking animation
	if Input.is_key_pressed(KEY_SHIFT):
		speed = sprint_multiplier * default_speed
		if state == PlayerState.CARRYING_ITEM:
			$Movement.movement_anim = "RunCarry"
		else:
			$Movement.movement_anim = "Run"
	else:
		speed = default_speed
		if state == PlayerState.CARRYING_ITEM:
			$Movement.movement_anim = "WalkCarry"
		else:
			$Movement.movement_anim = "Walk"

func _process(_delta: float) -> void:
	carry_item()
	if state == PlayerState.WALK_TO: return
	# Start holding on an interactable, if there is one
	current_interactable = get_interactable()
	if current_interactable:
		# Detect the start of a click or hold
		if Input.is_action_just_pressed("ui_accept"):
			hold_start_time = Time.get_ticks_msec() / 1000.0
			is_holding = true
			#hacky, im so sorry
			if current_interactable is CuttingBoard:
				state = PlayerState.FROZEN
				travel_to_anim("CraftSmith")

		# Detect a click, or end of a hold
		if Input.is_action_just_released("ui_accept"):
			var hold_time = (Time.get_ticks_msec() / 1000.0) - hold_start_time
			if hold_time < CLICK_THRESHOLD: handle_interaction()
			is_holding = false
			state = PlayerState.NORMAL
			if current_interactable: current_interactable.cancel_hold()
			current_interactable = null

	# Inform the interactable of the current hold time
	if is_holding and current_interactable:
		var hold_time = (Time.get_ticks_msec() / 1000.0) - hold_start_time
		current_interactable.update_hold_time(hold_time)

func carry_item() -> void:
	if not carried_item: return
	if state == PlayerState.CARRYING_ITEM:
		carried_item.visible = true
	else:
		carried_item.visible = false


func _on_freeze():
	state = PlayerState.FROZEN


func _on_unfreeze():
	state = PlayerState.NORMAL


func get_interactable():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = interact_box.shape
	query.transform = interact_box.global_transform
	query.collision_mask = collision_layer

	var result = space_state.intersect_shape(query)
	for collision in result:
		var collider = collision.collider
		if collider is Interactable:
			return collider
	return null
