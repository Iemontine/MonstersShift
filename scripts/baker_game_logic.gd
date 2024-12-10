extends CanvasLayer

@export var points_required:int
@export var game_duration:float
@export var night_time:bool

@onready var help_labels: Control = $"../HelpLabels"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var points_label: Label = $Points
@onready var game_timer: Timer = $GameTimer

var start_game:bool 
var current_points:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game = false
	progress_bar.visible = false
	#progress bar logic
	progress_bar.max_value = game_duration
	game_timer.start(game_duration)
	if !night_time:
		progress_bar.visible = true
	help_labels.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_game:
		if current_points >= points_required:
				progress_bar.visible = false
				points_label.visible = false
				start_game = false
				if StoryManager.current_event <= StoryManager.Event.BAKER_FAIL_DAYTIME:
					StoryManager.transition_to_event(StoryManager.Event.BAKER_SUCCESS_DAYTIME)
					PlayerController.start_cutscene("baker_success_daytime_game")
				else:
					StoryManager.transition_to_event(StoryManager.Event.BAKER_SUCCESS_NIGHT)
					PlayerController.start_cutscene("baker_success_night")
		elif game_timer.is_stopped():
			start_game = false
			_on_game_timer_timeout()
		progress_bar.value = game_timer.get_time_left()
		points_label.text = str(current_points) + " / " + str(points_required)
		
		

func start_timer(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timer_completed"))
	get_tree().root.add_child(timer)
	timer.start()

func _on_game_timer_timeout() -> void:
	progress_bar.visible = false
	points_label.visible = false
	visible = false
	if !night_time:
		StoryManager.transition_to_event(StoryManager.Event.BAKER_FAIL_DAYTIME)
		PlayerController.start_cutscene("baker_fail_daytime")
	else: 
		StoryManager.transition_to_event(StoryManager.Event.BAKER_FAIL_NIGHT)
		PlayerController.start_cutscene("baker_fail_night")
	
func start_game_timer():
	# Start the game and timer
	start_game = true
	points_label.visible = true
	progress_bar.visible = true
	game_timer.start(game_duration)

func _on_npc_baker_point_earned() -> void:
	print("points earned")
	current_points += 1


func _on_npc_baker_night_point_earned() -> void:
	print("points earned")
	current_points += 1
