extends Camera3D

@export var player: NodePath
@export var distance: float = 5.0
@export var sensitivity: float = 1
@export var height: float = 2.0  # New height variable

var rotation_x: float = 0.0
var rotation_y: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if player:
		var player_node = get_node(player)
		var mouse_movement = Input.get_last_mouse_velocity()
		
		rotation_x -= mouse_movement.y * (sensitivity/1000)
		rotation_y -= mouse_movement.x * (sensitivity/1000)
		
		rotation_x = clamp(rotation_x, -90, 90)
		
		var local_rotation = Vector3(deg_to_rad(rotation_x), deg_to_rad(rotation_y), 0)
		var offset = Vector3(0, height, distance).rotated(Vector3(1, 0, 0), local_rotation.x).rotated(Vector3(0, 1, 0), local_rotation.y)
		
		global_transform.origin = player_node.global_transform.origin - offset
		look_at(player_node.global_transform.origin, Vector3.UP)
