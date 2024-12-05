extends Node

var _path : String = "user://save_game.sav"

signal save_done
signal load_done


func save_node(node:Node) -> String:
	var save = node.call("save")
	return JSON.stringify(save)

func load_node(node:Dictionary) -> void:
	var object = load(node["file"]).instantiate()
	node.erase("file")
	var scene = get_node(node["parent"])
	if not node["name"] == "Player":
		node.erase("parent")
		scene.add_child(object)
		object.global_position = Vector2(node["pos_x"], node["pos_y"])
	
	elif node["name"] == "Player":
		# ensure the current scene is the player's scene
		var last_pos = Vector2(node["pos_x"], node["pos_y"])
		var last_dir = Vector2(node["last_dir_x"], node["last_dir_y"])
		var scene_player := get_tree().get_current_scene().get_node("Player")
		var parent = node["parent"].replace("/root/", "")
		SceneManager.switch_scene_on_load(scene_player, parent, last_pos, last_dir)
		node.erase("parent")
		node.erase("last_dir_x")
		node.erase("last_dir_y")
		await SceneManager.scene_transition_completed
		object = get_tree().get_current_scene().get_node("Player")
		
	
	node.erase("pos_x")
	node.erase("pos_y")
	
	for i in node.keys():
		object.set(i, node[i])
	
func save_game() -> void:
	var save_file = FileAccess.open(_path, FileAccess.WRITE)
	var nodes_to_save := get_tree().get_nodes_in_group("savable")
	
	# save story state first so that we can load the time of day before the player
	var story_state := {"StoryCurrentEvent": StoryManager.current_event, "TimeOfDay": SceneManager.time_of_day};
	save_file.store_line(JSON.stringify(story_state))
	
	# load all savable nodes
	for node in nodes_to_save:
		if not node.has_method("save"):
			printerr("Node ", node.name, " is not savable, missing save() function") 
			continue
			
		save_file.store_line(save_node(node))
	
	
	save_done.emit()

func load_game() -> void:
	if not FileAccess.file_exists(_path):
		printerr("Save file ", _path, " doesn't exist")
		return
	
	var save_file = FileAccess.open(_path, FileAccess.READ)
	
	for node in get_tree().get_nodes_in_group("savable"):
		if not node.name == "Player":
			node.queue_free()
	
	while save_file.get_position() < save_file.get_length():
		var json := JSON.new()
		var line := save_file.get_line()
		var parse_flag := json.parse(line)
		if parse_flag != OK:
			printerr("Error: ", json.get_error_message(), " in ", line, " at line ", json.get_error_line())
			continue
		
		var data = json.data
		if data.has("StoryCurrentEvent"):
			StoryManager.transition_to_event(data["StoryCurrentEvent"])
			SceneManager.time_of_day = data["TimeOfDay"]
			continue
		load_node(data)
		
		
		pass
	
	load_done.emit()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		save_game()
		print("saved")
	
	if Input.is_action_just_pressed("load"):
		load_game()
		print("load")
		
	# print("Time of day: ", SceneManager.time_of_day)
