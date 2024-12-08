extends Node

# dictionary of tracks to their associated scenes, { scene:track }
# TODO: make these line up with actual scene names
var _tracks := {
	"Outside Day" : "",
	"Outside Evening" : "",
	"Outside Night" : "",
	"Bakery" : "",
	"Bakery Game Day": "",
	"Bakery Game Night": "",
	"Conbini" : "",
	"Treehouse" : ""
}
var _current_track : String
var _track_path := "res//assets/sound/music/"
var _use_custom_track : bool
var _custom_track : String

@onready var stream_player : AudioStreamPlayer2D

func _ready() -> void:
	stream_player = AudioStreamPlayer2D.new()
	SceneManager.scene_transition_completed.connect(_on_scene_transition_completed)
	
func _on_scene_transition_completed() -> void:
	
	if not _check_ouside():
		pass
	else:
		
		
		match SceneManager.time_of_day:
			SceneManager.TIME.DAY:
				if _current_track != _tracks["Outside Day"]:
					pass
			SceneManager.TIME.EVENING:
				pass
			SceneManager.Time.NIGHT:
				stream_player
				pass
		pass
	
	
	print(_current_track)
	
func _check_ouside() -> bool:
	return SceneManager.current_scene == "Treehouse_Exterior" or SceneManager.current_scene == "Town"
