extends OmniLight3D

var player: Node = null
var offset: Vector3 = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"../Player" # Adjust the path to your player node
	if player:
		offset = global_transform.origin - player.global_transform.origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		global_transform.origin = player.global_transform.origin + offset
