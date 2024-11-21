class_name NPC
extends CharacterBody2D


@export var speed: float = 50.0
@export var path: Path2D
@export var stop_points: Array[int] = []


@onready var anim = $SpriteLayer/AnimationPlayer
@onready var animation_tree = $SpriteLayers/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var path_follow: PathFollow2D = path.get_node_or_null("PathFollow2D")
@onready var original_speed = speed / 1000.0


var last_direction = Vector2.ZERO


func _ready() -> void:
	speed /= 1000.0


func travel_to_anim(animName:String, direction = null):
	if direction != null: last_direction = direction

	animation_tree.set("parameters/"+animName+"/blend_position", last_direction)
	animation_state.travel(animName)


func handle_movement(delta):
	if not path or not path_follow:
		return
		
	path_follow.progress_ratio += speed * delta
	var direction_vector = (path_follow.get_global_position() - global_position).normalized()
	global_position = path_follow.get_global_position()
	travel_to_anim("Walk", direction_vector)

	for stop_index in stop_points:
		if global_position.distance_to(path.curve.get_point_position(stop_index)) < 10:
			stop_event(stop_index)


func stop_event(stop_index):
	speed = 0
	await get_tree().create_timer(1).timeout
	speed = original_speed


func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()
	velocity = get_velocity()
