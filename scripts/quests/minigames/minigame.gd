extends Quest
class_name Minigame

var duration:float = 30.0 # default time for minigames is 30 seconds

var _timer : Timer

func start() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(duration)
	
	
func is_finished() -> bool:
	return _timer != null and _timer.is_stopped()
	
func finish() -> void:
	if not is_finished():
		return
	
	# emit some signal that the minigame is done
	
	
func get_quest_name() -> String:
	return "null minigame"
