extends Door
class_name TreehouseDoor


func _ready():
	destination_scene = "Treehouse_Interior"
	super()
	
func _on_interacted() -> void:
	$AnimatedSprite2D.play("treehouse_door_open")
	super()
