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


func _on_interacted() -> void:
	get_viewport().set_input_as_handled()


func interact() -> void:
	interacted.emit()


func _on_timeline_ended() -> void:
	unfreeze.emit()


func _on_timeline_started() -> void:
	freeze.emit()
