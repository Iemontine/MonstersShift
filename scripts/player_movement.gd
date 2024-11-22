extends Node


const ACCELERATION = 10
const FRICTION = 1000000


var velocity = Vector2.ZERO


var movement_anim:String = "Walk"
@export var enabled:bool = true
@onready var player = get_parent()


func _physics_process(delta):
	if enabled: move_player(delta)


func move_player(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength(("left"))
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength(("up"))
	input_vector = input_vector.normalized()
	
	if player.state == Player.PlayerState.WALK_TO:
		input_vector = player.last_direction
	elif player.state == Player.PlayerState.CUTSCENE_WALK:
		input_vector = player.cutscene_walk_direction
	elif player.state == Player.PlayerState.FROZEN:
		input_vector = Vector2.ZERO

	if input_vector != Vector2.ZERO:
		player.travel_to_anim(movement_anim, input_vector)
		velocity = input_vector * player.speed
	else:
		if player.state == player.PlayerState.NORMAL:
			player.travel_to_anim("Idle")
		elif player.state == Player.PlayerState.CARRYING_ITEM:
			player.travel_to_anim("IdleCarry")
		velocity = Vector2.ZERO
		
	player.set_velocity(velocity)
	player.move_and_slide()
	velocity = player.velocity
