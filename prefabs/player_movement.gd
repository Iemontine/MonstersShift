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

	if player.state == Player.PlayerState.CONTROLLED:
		input_vector = player.direction
	elif player.state == Player.PlayerState.LOCKED:
		input_vector = Vector2.ZERO

	if input_vector != Vector2.ZERO:
		player.travel_to_anim(movement_anim, input_vector)
		velocity = input_vector * player.speed
	else:
		if player.state != Player.PlayerState.LOCKED:	# Allows for animations to play out when LOCKED
			if player.state == Player.PlayerState.CARRYING_ITEM:
				player.travel_to_anim("IdleCarry")
			else:
				player.travel_to_anim("Idle")
		velocity = Vector2.ZERO
	
	if player.state == Player.PlayerState.CONTROLLED and player.path_following: 
		return
	player.set_velocity(velocity)
	player.move_and_slide()
