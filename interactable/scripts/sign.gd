extends Interactable
class_name Sign

func _process(_delta: float) -> void:
	pass

func _on_interacted() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.start('test')
	get_viewport().set_input_as_handled()

func interact() -> void:
	interacted.emit()

func _on_timeline_ended() -> void:
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	print("im telling you to unfreeze")
	unfreeze.emit()

func _on_timeline_started() -> void:
	Dialogic.timeline_started.disconnect(_on_timeline_started)
	print("im telling you to freeze")
	freeze.emit()
