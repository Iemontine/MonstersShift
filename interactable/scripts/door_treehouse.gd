extends Door
class_name TreehouseDoor


@export var _destination_scene:String = "Treehouse_Interior"


func _ready():
	destination_scene = _destination_scene
	door_name = "TreehouseDoor"
	super()
	
func _on_interacted() -> void:
	$AnimatedSprite2D.play("treehouse_door_open")
	super()
