extends Node
class_name SceneManager


var scene_path = "res://map/"
var dest_path: String
var dest_player: Player


func switch_scene(src_player: Player, destination: String, should_player_walk: bool) -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

	
	dest_path = scene_path + destination + ".tscn"
	var last_direction = src_player.last_direction
	src_player.get_tree().call_deferred("change_scene_to_file", dest_path)
	#src_player.get_parent().remove_child(src_player)
	
	# TODO: replace with actual await completed scene transition code
	await get_tree().create_timer(0.05).timeout
	
	var new_scene = get_tree().root.get_node(destination)
	dest_player = new_scene.get_node("Player")
	dest_player.last_direction = last_direction
	dest_player.frozen = true
	if should_player_walk:
		dest_player.walk_to = true
	dest_player.ignore_scene_switcher = true
	adjust_player_position(new_scene, dest_player)

	start_timer(0.5)
	

func start_timer(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timer_completed"))
	get_tree().root.add_child(timer)
	timer.start()


func on_timer_completed():
	dest_player.walk_to = false
	dest_player.ignore_scene_switcher = false
	dest_player.frozen = false


func adjust_player_position(new_scene, player):
	var scene_switcher = new_scene.get_node("SceneSwitcher")
	if player and scene_switcher:
		player.global_position = scene_switcher.global_position
		var camera = new_scene.get_node("Camera2D")
		if camera:
			camera.target = player
