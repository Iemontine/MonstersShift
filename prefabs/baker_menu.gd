extends CanvasLayer
@onready var start: Button = $Start
@onready var tutorial: Button = $Tutorial
@onready var baker_game_logic: CanvasLayer = $"../BakerGameLogic"


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
	Dialogic.start("how_to_play")
