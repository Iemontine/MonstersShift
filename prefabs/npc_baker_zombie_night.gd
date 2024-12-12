extends NPC
class_name BakerNPCNight

#check the _on_dialogic_signal function to change damage
#BAD CODE ALERT!!!
@export var attack_damage:float = 2

@onready var agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var carried_item: Sprite2D = $CarriedItem
@onready var carried_item_name: String = ""
@onready var chat_bubble: AnimatedSprite2D = $ChatBubble
@onready var window_marker: Marker2D = $WindowMarker
@onready var door_marker: Marker2D = $DoorMarker
@onready var eat_timer: Timer = $EatTimer
@onready var want_label: Label = $WantLabel
@onready var door_visual: Sprite2D = $"../DoorVisual"
@onready var door_progress_bar: ProgressBar = $"../DoorVisual/ProgressBar"
@onready var player: Player = $"../Player"
@onready var sprite_layers: PlayerSpriteLayers = $SpriteLayers
@onready var baker_game_logic: CanvasLayer = $"../BakerGameLogic"


signal point_earned

var baker_want: String
var food: Array[String] = ["Cake", "Cookie", "Brownie"]

var old_velocity = Vector2.ZERO
var travel_to_position:Vector2
var player_in_area:bool = false
var food_at_window:bool = false


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	baker_want = food.pick_random()
	travel_to_position = global_position
	state = NPCState.BAKER_GO_TO_DOOR
	want_label.text = baker_want
	super._ready()

func _physics_process(_delta: float) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED:	# Important it is both CONTROLLED and LOCKED
		super._physics_process(_delta)
		return
	if food_at_window:
		state = NPCState.BAKER_GO_TO_WINDOW
	
		
	agent_2d.target_position = travel_to_position
	var current_agent_position = global_position
	var next_path_position = agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * 50
	old_velocity = new_velocity
	
	match state:
		NPCState.BAKER_ATTACKING_DOOR:
			if agent_2d.is_navigation_finished():
				travel_to_anim("MoodMadStomp", Vector2(0,1))
				#TODO: play breaking sound
				door_progress_bar.value -= attack_damage * _delta
				if door_progress_bar.value <= 0.2:
					#TODO: play door break sound
					door_visual.visible = false
					state = NPCState.BAKER_ATTACKING_PLAYER
		NPCState.BAKER_EAT_FOOD:
			if agent_2d.is_navigation_finished():
				travel_to_anim("MilkCow", Vector2(1,0))
		NPCState.BAKER_GO_TO_DOOR:
			if agent_2d.is_navigation_finished():
				state = NPCState.BAKER_ATTACKING_DOOR
			travel_to_position = door_marker.position
			travel_to_anim("Walk",Vector2(-1,0))
		NPCState.BAKER_GO_TO_WINDOW:
			travel_to_anim("Walk",Vector2(1,0))
			travel_to_position = window_marker.position
			if agent_2d.is_navigation_finished():
				eat_timer.start(2)
				point_earned.emit()
				state = NPCState.BAKER_EAT_FOOD
				food_at_window = false
		NPCState.BAKER_ATTACKING_PLAYER:
			travel_to_position = player.position
			agent_2d.target_position = travel_to_position
			agent_2d.path_desired_distance = 5
			agent_2d.target_desired_distance = 5
			player.state = Player.PlayerState.LOCKED
			sprite_layers.z_index = 10
			want_label.text = "BRAINS!!!"
			baker_game_logic.game_timer.stop()
			player.travel_to_anim("MoodShocked")
			if agent_2d.is_navigation_finished():
				player.travel_to_anim("Death")
			
			

		
	if agent_2d.avoidance_enabled:
		agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

	super._physics_process(_delta)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED: return
	velocity = safe_velocity

func _contains_string_in_dict(target_string: String, dictionary: Dictionary) -> bool:
	for value in dictionary.values():
		if target_string in value:
			return true
	return false

func _on_eat_timer_timeout() -> void:
	state = NPCState.BAKER_GO_TO_DOOR
	eat_timer.stop()
	baker_want = food.pick_random()
	want_label.text = baker_want
	
func _on_dialogic_signal(argument:String):
	if argument == "damage_zero":
		attack_damage = 0
	elif argument == "return_damage":
		attack_damage = 2
		
