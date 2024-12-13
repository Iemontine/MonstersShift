extends Node

# all on a linear scale, seems like 1.0 is the max before it gets bad
const max_vol : float = 0.5
const min_vol : float = 0.0
const default_vol : float = max_vol

# in dB
var volume : float = linear_to_db(default_vol)

# dictionary of tracks to their associated scenes, { scene:track }
# TODO: make sure non outside tracks line up with scene names
# TODO: FIND TRACKS
var _tracks := {
	"Outside Day" : "outside_day.wav",
	"Outside Evening" : "outside_evening.wav",
	"Outside Night" : "outside_night.wav",
	"bakery" : "bakery_game_day.wav",
	"bakery_no_game": "bakery.wav",
	"treehouse_interior_baker_game": "bakery_game_night.wav",
	"conbini" : "conbini.wav",
	"treehouse_interior" : "inside_treehouse.wav",
	"main_menu": "main_menu.wav"
}
var _current_track : String
var _track_path := "res://assets/sound/music/"
var _use_custom_track : bool = false
var _custom_track : String = "test_audio.WAV"
var _current_playtime : float = 190.0

@onready var stream_player : AudioStreamPlayer

func _ready() -> void:
	
	SceneManager.scene_transition_completed.connect(_on_scene_transition_completed)
	_on_scene_transition_completed()
	
func _process(_delta: float) -> void:
	if is_instance_valid(stream_player):
		_current_playtime = stream_player.get_playback_position()
		

func _on_scene_transition_completed() -> void:
	
	stream_player = AudioStreamPlayer.new()
	
	if _use_custom_track:
		if not (FileAccess.file_exists(_track_path + _custom_track)):
			return
		var stream = load(_track_path + _custom_track)
		stream_player.stream = stream
		if _current_track != _custom_track and _custom_track != "":
			_current_playtime = 0.0
			_current_track = _custom_track
			pass
		pass
	elif not _check_ouside():
		if SceneManager.current_scene:	# Added this line, TODO: current_scene not guaranteed a value on init
			if not _tracks.has(SceneManager.current_scene.to_lower()) or \
			   not (FileAccess.file_exists(_track_path + _tracks[SceneManager.current_scene.to_lower()])):
				return
			var stream = load(_track_path + _tracks[SceneManager.current_scene.to_lower()])
			stream_player.stream = stream
			if _current_track != _tracks[SceneManager.current_scene.to_lower()]:
				_current_playtime = 0.0
				_current_track = _tracks[SceneManager.current_scene.to_lower()]

			
	else:
		match SceneManager.time_of_day:
			SceneManager.TIME.DAY:
				if not (FileAccess.file_exists(_track_path + _tracks["Outside Day"])):
					return
				var stream = load(_track_path + _tracks["Outside Day"])
				stream_player.stream = stream
				if _current_track != _tracks["Outside Day"]:
					_current_playtime = 0.0
					_current_track = _tracks["Outside Day"]
			SceneManager.TIME.EVENING:
				if not (FileAccess.file_exists(_track_path + _tracks["Outside Evening"])):
					return
				var stream = load(_track_path + _tracks["Outside Evening"])
				stream_player.stream = stream
				if _current_track != _tracks["Outside Evening"]:
					_current_playtime = 0.0
					_current_track = _tracks["Outside Evening"]
			SceneManager.TIME.NIGHT:
				if not (FileAccess.file_exists(_track_path + _tracks["Outside Night"])):
					return
				var stream = load(_track_path + _tracks["Outside Night"])
				stream_player.stream = stream
				if _current_track != _tracks["Outside Night"]:
					_current_playtime = 0.0
					_current_track = _tracks["Outside Night"]
		
	stream_player.volume_db = volume
	get_tree().current_scene.add_child(stream_player)
	stream_player.play(_current_playtime)
	print(_current_track)
	print(volume)

func use_custom_track(track:String) -> void:
	_use_custom_track = true
	_custom_track = track

func end_custom_track() -> void:
	_use_custom_track = false
	_custom_track = ""

func play_custom_track(track:String, delay:float = 0.5):
	use_custom_track(track)
	if not (FileAccess.file_exists(_track_path + track)):
		return
	
	if stream_player:
		stream_player.stop()
		stream_player.queue_free()
	stream_player = AudioStreamPlayer.new()
	var stream = load(_track_path + track)
	var timer := Timer.new()
	timer.wait_time = delay
	timer.one_shot = true
	get_tree().current_scene.add_child(timer)
	timer.start()
	await timer.timeout
	stream_player.stream = stream
	_current_playtime = 0.0
	get_tree().current_scene.add_child(stream_player)
	
	# Set volume to 0 before starting playback
	stream_player.play(_current_playtime)

	# why THE FUCK CAN YOU NOT TWEEN VOLUME_DB?????
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(stream_player, "volume_db", linear_to_db(max_vol), 1.0).from(-100)
	tween.play()

func pause():
	if stream_player:
		stream_player.stream_paused = true


func unpause():
	if stream_player:
		stream_player.stream_paused = false

func stop():
	if stream_player:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(stream_player, "volume_db", -100, 3.0)
		await tween.finished
		if stream_player:
			stream_player.stop()
		if _use_custom_track:
			end_custom_track()

func set_volume(vol:float) :
	vol = clamp(vol, min_vol, max_vol)
	volume = linear_to_db(vol)
	
func _check_ouside() -> bool:
	if SceneManager.current_scene == null:
		return false
	return SceneManager.current_scene.to_lower() == "treehouse_exterior" or SceneManager.current_scene.to_lower() == "town"
