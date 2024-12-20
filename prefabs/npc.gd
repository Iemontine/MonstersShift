extends CharacterBody2D
class_name NPC

@export var speed: float = 1000.0

@onready var original_speed = speed / 1000.0
@onready var anim = $SpriteLayers/AnimationPlayer
@onready var animation_tree = $SpriteLayers/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var last_direction = Vector2.ZERO

enum NPCState { NORMAL, LOCKED, CONTROLLED, 
				#Daytime baker
				BAKER_IDLE, BAKER_HOLDING_ITEM, BAKER_DELIVERING, BAKER_RETURNING, 
				#Night baker
				BAKER_ATTACKING_DOOR, BAKER_GO_TO_DOOR, BAKER_GO_TO_WINDOW, BAKER_EAT_FOOD, BAKER_ATTACKING_PLAYER, 
				#NPC Customer
				BASIC_PATH_FINDING, BASIC_ARRIVED, BASIC_LEAVING, BASIC_DESTROY,
				WIDOW_ATTACKING, WIDOW_BACKING_OFF, WIDOW_IDLE }
var state: NPCState = NPCState.NORMAL
var movement_anim = "Walk"

func _ready() -> void:
	speed /= 1000.0

func travel_to_anim(animName:String, direction = null):
	if direction != null: last_direction = direction
	animation_tree.set("parameters/"+animName+"/blend_position", last_direction)
	animation_state.travel(animName)

func _physics_process(_delta):
	move_and_slide()

func move(direction: Vector2) -> void:
	last_direction = direction
	state = NPCState.CONTROLLED
	# match direction:
	# 	Vector2.UP:
	# 		print("NPC Moving up")
	# 	Vector2.DOWN:
	# 		print("NPC Moving down")
	# 	Vector2.LEFT:
	# 		print("NPC Moving left")
	# 	Vector2.RIGHT:
	# 		print("NPC Moving right")
	travel_to_anim(movement_anim, direction)
	velocity = direction.normalized() * speed

func stop() -> void:
	state = NPCState.LOCKED
	travel_to_anim("Idle")
	velocity = Vector2.ZERO

func playAnimation(animName: String, direction: Vector2) -> void:
	state = NPCState.LOCKED
	travel_to_anim(animName, direction)
# You must follow playAnimation with animationComplete
func animationComplete() -> void:
	state = NPCState.CONTROLLED
	travel_to_anim("Idle")

func setMovementAnim(animName: String) -> void:
	movement_anim = animName

func setSpeed(_speed: float) -> void:
	self.speed = _speed

func sprint() -> void:
	self.speed = original_speed * 2

func resetSpeed() -> void:
	self.speed = original_speed
