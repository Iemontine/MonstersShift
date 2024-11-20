extends Quest
class_name TestQuest

func _init() -> void:
	QuestSignals.end_quest_test.connect(_finish)

func start() -> void:
	QuestSignals.test_quest.emit()
	super()

func get_quest_name() -> String:
	return "Test Quest"
