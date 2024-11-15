extends Node

const ACCELERATION = 10
const FRICTION = 1000000

var velocity = Vector2.ZERO

@export var movement_anim:String = "Walk"
@export var enabled:bool = true
@onready var player = get_parent()

func _physics_process(delta):
	if enabled: move_player(delta)

func move_player(delta):
	var input_vector = Vector2.ZERO
	if player.walk_to:
		input_vector = player.last_direction
	elif player.cutscene_walk:
		input_vector = player.cutscene_walk_direction
	elif not player.frozen:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength(("ui_left"))
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength(("ui_up"))
		input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		player.travel_to_anim(movement_anim, input_vector)
		velocity = velocity.move_toward(input_vector * player.speed, (ACCELERATION * player.speed) * delta)
	else:
		player.travel_to_anim("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, (FRICTION * player.speed) * delta)
		
	player.set_velocity(velocity)
	player.move_and_slide()
	velocity = player.velocity
