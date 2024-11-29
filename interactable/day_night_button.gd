extends Interactable
class_name DayNightButton


@onready var surroundings:CanvasModulate = get_parent().get_node("Surroundings")
@onready var light:PointLight2D = get_parent().get_node("TreehouseLight")


func _on_interacted() -> void:
	if surroundings.color == Color("#132771"):
		light.enabled = false
		surroundings.color = Color("#ffffff")
	else:
		light.enabled = true
		surroundings.color = Color("#132771")
	super()
