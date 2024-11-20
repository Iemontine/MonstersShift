extends Quest
class_name Minigame

var duration:float = 30.0 # default time for minigames is 30 seconds
var _timer : Timer
var score : int # minigame dependent on how to calculate

# emit this signal from dialogue (link to setup) 
signal call_start(minigame:Minigame)
# emit this signal at the end see below
signal game_done(game : Minigame)


# for each function make sure to call super

func setup() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	MinigameManager.set_game(self)
	
func start() -> void:
	_timer.start(duration) 
	
# how each minigame is done is done on a per minigame basis, 
func update() -> void:
	# will update timer print 
	$Label.text = int(_timer.time_left) % 60
	
	
func is_finished() -> bool:
	return _timer != null and _timer.is_stopped()
	
func finish() -> void:
	if not is_finished():
		return
	
	# emit some signal that the minigame is done
	# either link this signal to the character or the quest
	# need to talk ab which we want to do ^^
	game_done.emit(self)
	# potential idea is tie each minigame as a part of a quest and use this signal to trigger progression
	# signal should also be used to update any flags for nighttime stuff
	queue_free()

# special overload for minigames	
func get_quest_name() -> String:
	return "null minigame"
