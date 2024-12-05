extends Interactable
class_name RecipeBoard

var board_visible: bool
@onready var board_ui: CanvasLayer = $Board_UI
var player_last_state: Player.PlayerState

func _ready() -> void:
	board_visible = false
	board_ui.visible = false
	super()

func _on_interacted() -> void:
	player_last_state = player.state
	board_ui.visible = !board_ui.visible

	
