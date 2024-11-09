extends Interactable
class_name Sign

func _process(_delta: float) -> void:
	pass

func _on_interacted() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.start('test')
	super()

func interact() -> void:
	interacted.emit()
	super()

func _on_timeline_ended() -> void:
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	super()

func _on_timeline_started() -> void:
	Dialogic.timeline_started.disconnect(_on_timeline_started)
	super()
