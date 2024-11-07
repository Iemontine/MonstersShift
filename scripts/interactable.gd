extends StaticBody2D
class_name Interactable

signal interacted
signal freeze
signal unfreeze

@onready var player = get_node("../../Player")

func _ready() -> void:
	connect("interacted", Callable(self, "_on_interacted"))
	connect("freeze", Callable(player, "_on_freeze"))
	connect("unfreeze", Callable(player, "_on_unfreeze"))

func _process(delta: float) -> void:
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
