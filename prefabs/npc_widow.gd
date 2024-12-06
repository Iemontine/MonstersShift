extends NPC
class_name WidowNPC

var player:Player
var player_in_area:bool = false

func _ready() -> void:
	state = NPCState.NORMAL # TODO: WIDOW_IDLE? widow states?
	super._ready()

func _physics_process(_delta: float) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED:	# Important it is both CONTROLLED and LOCKED
		super._physics_process(_delta)
		return
		
	# agent_2d.target_position = travel_to_position
	# var current_agent_position = global_position
	# var next_path_position = agent_2d.get_next_path_position()
	# var new_velocity = current_agent_position.direction_to(next_path_position) * 50
	# old_velocity = new_velocity
	
	# match state:
	# 	NPCState.BAKER_IDLE:
	# 		travel_to_anim("Idle", Vector2(0,1))
	# 		if player_in_area and Input.is_action_pressed("ui_accept"):
	# 			on_interacted()
	# 	NPCState.BAKER_HOLDING_ITEM:
	# 		travel_to_anim("WalkCarry", old_velocity)
	# 		for key in customer_want:
	# 			if customer_want[key] == carried_item_name:
	# 				print(key)
	# 				current_chair_target = key
	# 				travel_to_position = key.global_position
	# 				customer_want.erase(key)
	# 				state = NPCState.BAKER_DELIVERING
	# 				break
	# 	NPCState.BAKER_DELIVERING:
	# 		travel_to_anim("WalkCarry", old_velocity)
	# 		if agent_2d.is_navigation_finished():
	# 			point_earned.emit()
	# 			carried_item_name = ""
	# 			state = NPCState.BAKER_RETURNING
	# 			travel_to_position = spawn_location
	# 			#make NPC return to door
	# 			current_chair_target.npc.state = NPCState.BASIC_LEAVING
	# 			customer_want.erase(current_chair_target)
	# 	NPCState.BAKER_RETURNING:
	# 		if agent_2d.is_navigation_finished():
	# 			state = NPCState.BAKER_IDLE
	
	# if agent_2d.is_navigation_finished():
	# 	return
		
	# if agent_2d.avoidance_enabled:
	# 	agent_2d.set_velocity(new_velocity)
	# else:
	# 	_on_navigation_agent_2d_velocity_computed(new_velocity)

	super._physics_process(_delta)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED: return
	velocity = safe_velocity

func on_interacted() -> void:
	print("Interacted with Widow")

func _on_area_2d_body_entered(_body: Object) -> void:
	if _body is Player:
		player = _body
		player_in_area = true

func _on_area_2d_body_exited(_body: Object) -> void:
	if _body is Player:
		player_in_area = false