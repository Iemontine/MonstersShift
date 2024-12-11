extends Interactable
class_name RecipeBoard

var board_visible: bool
@onready var board_ui: CanvasLayer = $Board_UI
var viewing = false

func _ready() -> void:
	board_visible = false
	board_ui.visible = false
	super()
	
func _process(delta: float) -> void:
	if viewing: player.state = Player.PlayerState.CONTROLLED

func _on_interacted() -> void:
	viewing = !viewing
	board_ui.visible = viewing
	super()
