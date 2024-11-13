extends Node

# while minigames are a subset of quests, the actual handling of them is different

var _current : Minigame = null

func set_game(minigame : Minigame) -> void:
	if _current != null:
		printerr("Finish current minigame first")
		return
		
	_current = minigame
	start_game()

func start_game() -> void:
	_current.start()
	
func update() -> void:
	if _current.is_finished():
		_current.finish()
		_current = null
	else:
		_current.update()
	
func _process(delta: float) -> void:
	if _current != null:
		update()
