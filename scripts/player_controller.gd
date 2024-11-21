class_name PlayerController
extends Node2D


var player: Player
var cmd_list: Array
var timer_list: Array[Timer] = []
var signal_list: Array[String]
var dialog_started: bool = false


func _init(body: Player) -> void:
	player = body


func queue_command(command: Vector2, duration: float):
	cmd_list.push_back(command)
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer_list.push_back(timer)
	add_child(timer)


func start_dialogue(dialogue_name: String, signal_name: String):
	cmd_list.push_back(dialogue_name)
	signal_list.push_back(signal_name)
	
	if has_signal(signal_name):
		print(has_signal)


func _on_dialogic_signal(signal_name: String):
	if signal_list.is_empty(): return
	if signal_name == signal_list.front():
		print("Something was activated!")
	cmd_list.pop_front()
	signal_list.pop_front()
	dialog_started = false


func _process(_delta: float) -> void:
	if cmd_list.front() is Vector2:
		player.state = Player.PlayerState.CUTSCENE_WALK
		player.cutscene_walk_direction = cmd_list.front()
		
		if timer_list.front().is_stopped():
			timer_list.front().start()
		elif timer_list.front().time_left < 0.1:
			player.state = Player.PlayerState.NORMAL
			timer_list.pop_front()
			cmd_list.pop_front()
	elif cmd_list.front() is String and dialog_started == false:
			dialog_started = true
			Dialogic.signal_event.connect(_on_dialogic_signal)
			Dialogic.start("cutscene")
