extends CanvasLayer

@onready var baker_game_logic: CanvasLayer = $"../BakerGameLogic"
@export var player: Player
@onready var start: Button = $Start
@onready var tutorial: Button = $Tutorial


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	baker_game_logic.start_game_timer()
	visible = false


func _on_tutorial_pressed() -> void:
		StoryManager.transition_to_event(StoryManager.Event.CLICK_ON_BED)
		PlayerController.start_cutscene("how_to_play")
		visible = false
