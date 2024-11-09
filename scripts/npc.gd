class_name NPC
extends CharacterBody2D

@export var speed: float = 50.0
@export var path: Path2D
@export var stop_points: Array[int] = []


@onready var anim = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var path_follow: PathFollow2D = path.get_node("PathFollow2D")
@onready var original_speed = speed / 1000.0

var last_direction = Vector2.ZERO

func _ready() -> void:
	speed /= 1000.0

func handle_movement(delta):
	if !path or !path_follow:
		return
		
	path_follow.progress_ratio += speed * delta
	var direction_vector = (path_follow.get_global_position() - global_position).normalized()
	global_position = path_follow.get_global_position()
	animation_tree.set("parameters/walk/blend_position", direction_vector)

	for stop_index in stop_points:
		print(stop_index, " ", global_position.distance_to(path.curve.get_point_position(stop_index)))
		if global_position.distance_to(path.curve.get_point_position(stop_index)) < 10:
			stop_event(stop_index)

func stop_event(index):
	speed = 0
	await get_tree().create_timer(1.0).timeout
	#match index:
		#0:
			#await get_tree().create_timer(5.0).timeout
			##anim.play("animation_1")
		#1:
			#await get_tree().create_timer(5.0).timeout
			##anim.play("animation_2")
	speed = original_speed

func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()
