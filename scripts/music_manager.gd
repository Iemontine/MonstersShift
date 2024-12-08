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
var _track_path := "res://assets/sound/music/"
var _use_custom_track : bool = true
var _custom_track : String = "test_audio.WAV"
var _current_playtime : float = 0.0

@onready var stream_player : AudioStreamPlayer2D 

func _ready() -> void:
	
	SceneManager.scene_transition_completed.connect(_on_scene_transition_completed)
	_on_scene_transition_completed()
	
func _process(delta: float) -> void:
	if is_instance_valid(stream_player):
		_current_playtime = stream_player.get_playback_position()
		
	print(_current_playtime)

func _on_scene_transition_completed() -> void:
	
	stream_player = AudioStreamPlayer2D.new()
	
	if _use_custom_track:
		var stream = load(_track_path + _custom_track)
		stream_player.stream = stream
		if _current_track != _custom_track and _custom_track != "":
			_current_playtime = 0.0
			_current_track = _custom_track
			pass
		pass
	elif not _check_ouside():
		if _current_track != _tracks[SceneManager.current_scene]:
			stream_player.play()
			pass

			
	else:
		match SceneManager.time_of_day:
			SceneManager.TIME.DAY:
				if _current_track != _tracks["Outside Day"]:
					pass
			SceneManager.TIME.EVENING:
				if _current_track != _tracks["Outside Evening"]:
					pass
			SceneManager.Time.NIGHT:
				if _current_track != _tracks["Outside Day"]:
					pass
		
		
	
	get_tree().current_scene.add_child(stream_player)
	stream_player.play(_current_playtime)
	print(_current_track)

func use_custom_track(track:String) -> void:
	_use_custom_track = true
	_custom_track = track

func end_custom_track() -> void:
	_use_custom_track = false
	_custom_track = ""
	
func _check_ouside() -> bool:
	return SceneManager.current_scene == "Treehouse_Exterior" or SceneManager.current_scene == "Town"
