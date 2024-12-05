extends NPC
class_name WalkerNPC


var path_follow: PathFollow2D
@export var path: Path2D
@export var stop_points: Array[int] = []



func _ready() -> void:
	if path: path_follow = path.get_node_or_null("PathFollow2D")


func travel_to_anim(animName:String, direction = null):
	if direction != null: last_direction = direction

	animation_tree.set("parameters/"+animName+"/blend_position", last_direction)
	animation_state.travel(animName)


func handle_movement(delta):
	if not path or not path_follow: return
	path_follow.progress_ratio += speed * delta
	var direction_vector = (path_follow.get_global_position() - global_position).normalized()
	global_position = path_follow.get_global_position()
	travel_to_anim("Walk", direction_vector)


func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()
	velocity = get_velocity()
