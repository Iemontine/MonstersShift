class_name Player
extends CharacterBody2D

enum PlayerState { NORMAL, LOCKED, CONTROLLED, CARRYING_ITEM }
const CLICK_THRESHOLD = 0.5

# General variables
@onready var animationPlayer:AnimationPlayer = $SpriteLayers/AnimationPlayer
@onready var animationTree:AnimationTree = $SpriteLayers/AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

# Variables related to movement
@onready var default_speed = speed
@onready var movement = $Movement
@export var speed = 100
@export var sprint_multiplier = 2
var direction:Vector2 = Vector2.ZERO
var sprint_enabled: bool = true

# Variables related to interactables
@onready var interact_box = $InteractBox/CollisionShape2D
@onready var carried_item: Sprite2D = $CarriedItem
@onready var carried_item_name: String = ""
var state:PlayerState = PlayerState.NORMAL
var hold_start_time = 0.0
var is_holding = false
var current_interactable = null # current target interactable being held on

# Used during Widow minigame
var path_follow: PathFollow2D
var path_following: bool = false
var distance_travelled: float = 0
signal path_follow_completed

func _ready():
	animationTree.set_animation_player(animationPlayer.get_path())
	animationTree.active = true
	speed = default_speed
	PlayerController.player = self

func _physics_process(delta):
	if path_following:
		state = PlayerState.CONTROLLED
		_on_path_follow_timeout(delta)

	move_interact_box()

	if state == PlayerState.LOCKED: 
		return
		

	update_speed_and_animation()

func _process(_delta: float) -> void:
	# TODO: delete label
	var state_names = ["NORMAL", "LOCKED", "CONTROLLED", "CARRYING_ITEM"]
	$Label.text = "State: " + state_names[int(state)] + ", Animation: " + animationState.get_current_node()

	var qte = get_tree().get_root().get_node_or_null(("QTE"))
	if qte and qte.is_active: return

	carry_item()
	carried_item.visible = state == PlayerState.CARRYING_ITEM or path_following
	if state == PlayerState.CONTROLLED: return

	current_interactable = get_interactable()
	if current_interactable:
		handle_input()

	var hold_time = (Time.get_ticks_msec() / 1000.0) - hold_start_time
	if is_holding and current_interactable and hold_time >= CLICK_THRESHOLD:
		if state == PlayerState.NORMAL or state == PlayerState.LOCKED:	# hacky
			update_hold_time()

func travel_to_anim(animName: String, _direction = null):
	if _direction != null: direction = _direction
	animationTree.active = true
	animationTree.set("parameters/" + animName + "/blend_position", direction)
	animationState.travel(animName)

func move_interact_box():
	if direction == Vector2.UP:
		interact_box.position = Vector2(0, -17)
	elif direction == Vector2.DOWN:
		interact_box.position = Vector2(0, 17)
	elif direction == Vector2.LEFT:
		interact_box.position = Vector2(-19, -13.25)
	elif direction == Vector2.RIGHT:
		interact_box.position = Vector2(19, -13.25)

func handle_interaction():
	if (state == PlayerState.LOCKED and not is_holding) or state == PlayerState.CONTROLLED:
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

func update_speed_and_animation():
	if path_following: return
	if sprint_enabled and Input.is_key_pressed(KEY_SHIFT):
		speed = sprint_multiplier * default_speed
		if state == PlayerState.CARRYING_ITEM:
			movement.movement_anim = "RunCarry"
		else:
			movement.movement_anim = "Run"
	else:
		if state != PlayerState.CONTROLLED:
			speed = default_speed
		if state == PlayerState.CARRYING_ITEM:
			movement.movement_anim = "WalkCarry"
		elif state != PlayerState.CONTROLLED and !path_following:
			movement.movement_anim = "Walk"

func handle_input():
	if Input.is_action_just_pressed("ui_accept"):
		hold_start_time = Time.get_ticks_msec() / 1000.0
		is_holding = true

	if Input.is_action_just_released("ui_accept"):
		var hold_time = (Time.get_ticks_msec() / 1000.0) - hold_start_time
		if hold_time < CLICK_THRESHOLD:
			handle_interaction()
		is_holding = false
		if state != PlayerState.CARRYING_ITEM and state != PlayerState.LOCKED:
			state = PlayerState.NORMAL
		if current_interactable:
			current_interactable.cancel_hold()
		current_interactable = null

	if is_holding:
		var hold_time = (Time.get_ticks_msec() / 1000.0) - hold_start_time
		if hold_time >= CLICK_THRESHOLD:
			if state != PlayerState.CARRYING_ITEM and current_interactable is CuttingBoard and (current_interactable as CuttingBoard).items.size() > 0 and !current_interactable.is_locked:
				state = PlayerState.LOCKED
				travel_to_anim("WorkAtDesk1")

func update_hold_time():
	var hold_time = (Time.get_ticks_msec() / 1000.0) - hold_start_time
	current_interactable.update_hold_time(hold_time)

func carry_item() -> void:
	if not carried_item: return
	carried_item.visible = state == PlayerState.CARRYING_ITEM or path_following # TODO: and state is DAY_WIDOW_GAME

func _on_freeze():
	state = PlayerState.LOCKED

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

func save():
	var dict := {
		"file": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"pos_x": global_position.x,
		"pos_y": global_position.y,
		"last_dir_x": direction.x,
		"last_dir_y": direction.y,
		"name": name
	}
	return dict
	
# ============================= WIDOW MINIGAME =================================

# Follows a path child to the root, called when the minigame starts
func follow_path():
	var path = get_parent().get_node_or_null("Path2D")
	path_follow = path.get_node_or_null("PathFollow2D")
	if not path_follow: return
	path_follow.progress_ratio = 0
	path_follow.set_loop(false)
	path_follow.set_cubic_interpolation(true)
	path_following = true

# Called when the player is following a path in _physics_process()
func _on_path_follow_timeout(delta):
	var path : Path2D = get_parent().get_node_or_null("Path2D")
	var path_length = path.curve.get_baked_length()

	distance_travelled = path_follow.progress_ratio * path_length

	# Progress along the path
	path_follow.progress_ratio += (speed / path_length) * delta
	direction = (path_follow.get_global_position() - global_position).normalized()
	
	global_position = path_follow.get_global_position()
	travel_to_anim(get_node("Movement").movement_anim)
	if path_follow.progress_ratio >= 1.0:
		path_following = false
		state = PlayerState.NORMAL
		emit_signal("path_follow_completed")

func kill_player():
	state = PlayerState.LOCKED
	travel_to_anim("Death")

func enable_sprint():
	sprint_enabled = true

func disable_sprint():
	sprint_enabled = false
