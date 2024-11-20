extends Door
class_name TestQuestDoor

var locked : bool = true

func _init() -> void:
	QuestSignals.test_quest.connect(_unlock)

func _on_interacted() -> void:
	if not locked:
		QuestSignals.end_quest_test.emit()
		super()

func _unlock() -> void:
	locked = false
