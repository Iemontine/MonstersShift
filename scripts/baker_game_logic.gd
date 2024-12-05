extends CanvasLayer

@export var points_required:int
@export var game_duration:float

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var points_label: Label = $Points
@onready var game_label: Label = $GameLabel
@onready var game_timer: Timer = $GameTimer

var start_game:bool
var current_points:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game = true
	
	#progress bar logic
	progress_bar.max_value = game_duration
	game_timer.start(game_duration)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_game:
		if current_points >= points_required:
				game_label.text = "You Win!"
				game_label.visible = true
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
	game_label.text = "Game Over!"
	game_label.visible = true


func _on_npc_baker_point_earned() -> void:
	print("points earned")
	current_points += 1