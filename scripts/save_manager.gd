extends Node

var _path : String = "user://save_game.sav"

func save_node(node:Node) -> String:
	var save = node.call("save")
	return JSON.stringify(save)

func load_node(node:Dictionary) -> void:
	var object = load(node["file"]).instantiate()
	#if not node["name"] == "Player":
	var scene = get_node(node["parent"])
	if not node["name"] == "Player":
		scene.add_child(object)
		object.global_position = Vector2(node["pos_x"], node["pos_y"])
		for i in node.keys():
			if i == "file" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			object.set(i, node[i])
	
	elif node["name"] == "Player":
		# ensure the current scene is the player's scene
		#var dest_path :String = "res://map/" + node["parent"].replace("/root/", "") + ".tscn"
		object.global_position = Vector2(node["pos_x"], node["pos_y"])
		scene_manager.switch_scene_on_load(get_tree().get_current_scene().get_node("Player"), node["parent"].replace("/root/", ""), false, object.global_position)
		await scene_manager.finished_switching
		object = get_tree().get_current_scene().get_node("Player")
		object.global_position = Vector2(node["pos_x"], node["pos_y"])
		object.last_direction = Vector2(node["last_dir_x"], node["last_dir_y"])
		for i in node.keys():
			if i == "file" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "last_dir_x" or i == "last_dir_y":
				continue
			object.set(i, node[i])
		
func save_game() -> void:
	var save_file = FileAccess.open(_path, FileAccess.WRITE)
	var nodes_to_save := get_tree().get_nodes_in_group("savable")
	for node in nodes_to_save:
		if not node.has_method("save"):
			printerr("Node ", node.name, " is not savable, missing save() function") 
			continue
			
		save_file.store_line(save_node(node))
	pass

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
			printerr("Save parse error: ", json.get_error_message(), " in ", line, " at line ", json.get_error_line())
			continue
		
		var data = json.data
		load_node(data)
		
		pass
		
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		save_game()
	
	if Input.is_action_just_pressed("load"):
		load_game()
