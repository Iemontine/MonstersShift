extends CharacterBody2D
class_name InteractableArea2D

signal interacted
signal freeze
signal unfreeze
signal hold_interacted

@export var required_hold_time = 2.5
var current_hold_time = 0.0

@onready var player: Player

func _ready() -> void:
	# Fixes finding player on factory-created nodes
	player = get_parent().get_node_or_null("Player")
	if player == null: player = get_parent().get_parent().get_node("Player")
	connect_signals()

func connect_signals():
	connect("interacted", Callable(self, "_on_interacted"))
	connect("freeze", Callable(player, "_on_freeze"))
	connect("unfreeze", Callable(player, "_on_unfreeze"))
	connect("hold_interacted", Callable(self, "_on_hold_interacted"))

func interact() -> void:
	interacted.emit()

func update_hold_time(hold_time: float) -> void:
	current_hold_time = hold_time
	if current_hold_time >= required_hold_time:
		hold_to_interact(hold_time)

func cancel_hold() -> void:
	current_hold_time = 0.0

func hold_to_interact(_hold_time: float) -> void:
	hold_interacted.emit()

func _on_interacted() -> void:
	get_viewport().set_input_as_handled()

func _on_hold_interacted() -> void:
	get_viewport().set_input_as_handled()

func _on_timeline_started() -> void:
	freeze.emit()

func _on_timeline_ended() -> void:
	unfreeze.emit()
