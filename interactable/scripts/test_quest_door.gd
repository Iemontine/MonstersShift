extends Door
class_name TestQuestDoor

var locked : bool = true

func _ready() -> void:
	QuestSignals.test_quest.connect(_unlock)

func _on_interacted() -> void:
	if not locked:
		super()

func _unlock() -> void:
	locked = false
