# SceneManager - Global Autoloaded Singleton
extends Node

enum TIME {DAY, EVENING, NIGHT}

signal scene_transition_completed

var scene_path = "res://map/"
var dest_path: String
var dest_player: Player

var current_scene: String
var time_of_day = TIME.DAY

func switch_scene_on_load(src_player: Player, destination: String, pos:Vector2, dir:Vector2) -> void:
	MusicManager.stream_player.stream_paused = true
	
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	
	if destination == "Main_Menu": scene_path = "res://mainmenu/"
	dest_path = scene_path + destination + ".tscn"
	var last_direction = src_player.direction
	src_player.get_tree().call_deferred("change_scene_to_file", dest_path)
	scene_path = "res://map/"
	
	# TODO: replace with actual await completed scene transition code
	await get_tree().create_timer(0.05).timeout
	
	var new_scene = get_tree().root.get_node(destination)
	dest_player = new_scene.get_node("Player")
	dest_player.direction = last_direction
	dest_player.state = Player.PlayerState.LOCKED
	
	var camera = new_scene.get_node("Camera2D")
	if camera:
		camera.target = dest_player
	
	current_scene = destination
	
	dest_player.global_position = pos
	dest_player.direction = dir
	handle_day_shift()
	start_timer(0.5)

func switch_scene(src_player: Player, destination: String, should_player_walk: bool, loadzone_name: String = "") -> void:
	if is_instance_valid(MusicManager.stream_player):
		MusicManager.stream_player.stream_paused = true
	
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

	if destination == "Main_Menu": scene_path = "res://mainmenu/"
	dest_path = scene_path + destination + ".tscn"
	var last_direction = src_player.direction
	scene_path = "res://map/"
	
	src_player.get_tree().call_deferred("change_scene_to_file", dest_path)
	
	# TODO: replace with actual await completed scene transition code
	await get_tree().create_timer(0.05).timeout
	
	var new_scene = get_tree().root.get_node(destination)
	current_scene = destination

	dest_player = new_scene.get_node("Player")
	dest_player.direction = last_direction
	dest_player.state = Player.PlayerState.LOCKED
	dest_player.travel_to_anim("Idle")
	if should_player_walk:
		dest_player.state = Player.PlayerState.CONTROLLED
	
	handle_day_shift()
	
	if loadzone_name.begins_with("Loadzone"):
		move_player_to_loadzone(new_scene, dest_player, loadzone_name)
	elif loadzone_name.begins_with("Door"):
		move_player_to_door(new_scene, dest_player, loadzone_name)
	
	start_timer(0.5)

func start_timer(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timer_completed"))
	get_tree().root.add_child(timer)
	timer.start()


func on_timer_completed():
	dest_player.state = Player.PlayerState.NORMAL
	emit_signal("scene_transition_completed")


func move_player_to_loadzone(new_scene, player, loadzone_name = "Loadzone"):
	var loadzone = new_scene.get_node(loadzone_name)
	if player and loadzone:
		player.global_position = loadzone.global_position
		var camera = new_scene.get_node("Camera2D")
		if camera:
			camera.target = player
			
func move_player_to_door(new_scene, player, door_name):
	var door = new_scene.get_node(door_name)
	var marker = door.get_node("Spawnpoint")
	if player and marker:
		player.global_position = marker.global_position

		var direction_vector = marker.global_position - door.global_position
		player.direction = direction_vector

		var camera = new_scene.get_node("Camera2D")
		if camera:
			camera.target = player

func handle_day_shift() -> void:
	var surroundings = get_tree().current_scene.get_node_or_null("Surroundings")
	var lights = get_tree().get_nodes_in_group("light")
	
	if time_of_day == TIME.DAY:
		for light in lights:
			light.enabled = false
		if surroundings:
			surroundings.color = Color("#ffffff")
	elif time_of_day == TIME.EVENING:
		for light in lights:
			light.enabled = true
			light.energy = 0.5
		if surroundings:
			surroundings.color = Color("#fabb7b")
	elif time_of_day == TIME.NIGHT:
		for light in lights:
			light.enabled = true
			light.energy = 1.0
		if surroundings:
			surroundings.color = Color("#313d9a")

# func change_time_of_day(player:Player) -> void:
# 	time_of_day = ( time_of_day + 1 ) % 3
# 	handle_day_shift(player)

func change_time_of_day(new_time_of_day: int = -1) -> void:
	if new_time_of_day == -1:
		time_of_day = TIME.values()[(time_of_day + 1) % 3]
	else:
		time_of_day = TIME.values()[new_time_of_day]
	
	handle_day_shift()

func switch_to_credits() -> void:
	get_tree().change_scene_to_file("res://credits/credits.tscn")
