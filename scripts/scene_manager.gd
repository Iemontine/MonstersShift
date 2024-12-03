# SceneManager - Global Autoloaded Singleton
extends Node

signal scene_transition_completed

var scene_path = "res://map/"
var dest_path: String
var dest_player: Player
var night : bool = false

func switch_scene_on_load(src_player: Player, destination: String, pos:Vector2, dir:Vector2) -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	
	dest_path = scene_path + destination + ".tscn"
	var last_direction = src_player.direction
	src_player.get_tree().call_deferred("change_scene_to_file", dest_path)
	
	# TODO: replace with actual await completed scene transition code
	await get_tree().create_timer(0.05).timeout
	
	var new_scene = get_tree().root.get_node(destination)
	dest_player = new_scene.get_node("Player")
	dest_player.direction = last_direction
	dest_player.state = Player.PlayerState.LOCKED
	
	var camera = new_scene.get_node("Camera2D")
	if camera:
		camera.target = dest_player
	
	dest_player.global_position = pos
	dest_player.direction = dir
	handle_day_shift(dest_player)
	start_timer(0.5)

func switch_scene(src_player: Player, destination: String, should_player_walk: bool, loadzone_name: String = "") -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

	dest_path = scene_path + destination + ".tscn"
	var last_direction = src_player.direction
	src_player.get_tree().call_deferred("change_scene_to_file", dest_path)
	
	# TODO: replace with actual await completed scene transition code
	await get_tree().create_timer(0.05).timeout
	
	var new_scene = get_tree().root.get_node(destination)
	dest_player = new_scene.get_node("Player")
	dest_player.direction = last_direction
	dest_player.state = Player.PlayerState.LOCKED
	dest_player.travel_to_anim("Idle")
	if should_player_walk:
		dest_player.state = Player.PlayerState.CONTROLLED
	
	handle_day_shift(dest_player)
	
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

func handle_day_shift(player:Player) -> void:
	
	var surroundings:= player.get_parent().get_node_or_null("Surroundings")
	var lights := get_tree().get_nodes_in_group("light")
	
	if not night:
		for light in lights:
			light.enabled = false
		if surroundings != null:
			surroundings.color = Color("#ffffff")
	else:
		for light in lights:
			light.enabled = true
		if surroundings != null:
			surroundings.color = Color("#132771")

func change_time_of_day(player:Player) -> void:
	night = not night
	handle_day_shift(player)
